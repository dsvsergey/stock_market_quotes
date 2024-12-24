// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import 'statistics_table.dart';

class HomeScreen extends ConsumerWidget {
  final String windowTitle;

  const HomeScreen({
    super.key,
    required this.windowTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final connectionState = ref.watch(connectionStateProvider);
    ref.watch(lastQuotesProvider(100));

    final connectionColor = _getConnectionColor(connectionState);
    final connectionIcon = _getConnectionIcon(connectionState);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          _buildStatusIcon(
            icon: connectionIcon,
            color: connectionColor,
            theme: theme,
          ),
          const SizedBox(width: 18),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
            ),
            onPressed: () async {
              final databaseService = ref.read(databaseServiceProvider);
              final result = await databaseService.clearAllQuotes();
              result.fold(
                (failure) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(failure.message),
                    backgroundColor: theme.colorScheme.error,
                  ),
                ),
                (_) {
                  ref.read(statisticsUpdateProvider.notifier).state++;
                  ref.read(startTimeProvider.notifier).state = null;
                },
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.background,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StartStopButton(),
                  StatisticsButton(),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProviderScope(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final statisticsAsync = ref.watch(statisticsProvider);
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: statisticsAsync.when(
                              data: (statistics) => statistics != null
                                  ? Padding(
                                      key: ValueKey(
                                          'statistics_${statistics.calculatedAt.millisecondsSinceEpoch}'),
                                      padding: const EdgeInsets.all(16.0),
                                      child: StatisticsTable(
                                        statistics: statistics,
                                        l10n: l10n,
                                      ),
                                    )
                                  : Center(
                                      key: const ValueKey('no_data'),
                                      child: Text(
                                        l10n.noDataError,
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                              loading: () => const SizedBox.shrink(
                                  key: ValueKey('loading')),
                              error: (error, stack) => Center(
                                key: ValueKey('error_$error'),
                                child: Text(
                                  '${l10n.error}: $error',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon({
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 24,
      ),
    );
  }

  Color _getConnectionColor(WebSocketState state) {
    switch (state) {
      case WebSocketState.disconnected:
        return Colors.redAccent;
      case WebSocketState.connecting:
        return Colors.orangeAccent;
      case WebSocketState.receiving:
        return Colors.greenAccent;
    }
  }

  IconData _getConnectionIcon(WebSocketState state) {
    switch (state) {
      case WebSocketState.disconnected:
        return Icons.cloud_off;
      case WebSocketState.connecting:
        return Icons.cloud_sync;
      case WebSocketState.receiving:
        return Icons.cloud_done;
    }
  }
}

class StartStopButton extends ConsumerWidget {
  const StartStopButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final connectionState = ref.watch(connectionStateProvider);

    return _buildActionButton(
      context: context,
      label: connectionState == WebSocketState.disconnected
          ? l10n.start
          : l10n.stop,
      isEnabled: true,
      onPressed: () async {
        if (connectionState == WebSocketState.disconnected) {
          ref.read(connectionStateProvider.notifier).state =
              WebSocketState.connecting;
          final websocketService = ref.read(websocketServiceProvider);
          final result = await websocketService.connect();
          result.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
              ref.read(connectionStateProvider.notifier).state =
                  WebSocketState.disconnected;
            },
            (_) {
              ref.read(connectionStateProvider.notifier).state =
                  WebSocketState.receiving;
              if (ref.read(startTimeProvider) == null) {
                ref.read(startTimeProvider.notifier).state = DateTime.now();
              }
            },
          );
        } else {
          final websocketService = ref.read(websocketServiceProvider);
          await websocketService.disconnect();
          ref.read(connectionStateProvider.notifier).state =
              WebSocketState.disconnected;
        }
      },
    );
  }
}

class StatisticsButton extends ConsumerWidget {
  const StatisticsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final startTime = ref.watch(startTimeProvider);
    final isCalculating =
        ref.watch(statisticsProvider.select((value) => value.isLoading));

    return _buildActionButton(
      context: context,
      label: l10n.statistics,
      isEnabled: startTime != null && !isCalculating,
      onPressed: () {
        ref.read(statisticsUpdateProvider.notifier).state++;
      },
    );
  }
}

Widget _buildActionButton({
  required BuildContext context,
  required String label,
  required bool isEnabled,
  required VoidCallback onPressed,
}) {
  final theme = Theme.of(context);
  return SizedBox(
    height: 48,
    child: ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        disabledBackgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
        disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
        elevation: isEnabled ? 4 : 0,
      ),
      child: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isEnabled
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface.withOpacity(0.38),
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
