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
    final isIsolateRunning = ref.watch(websocketIsolateProvider).value ?? false;
    ref.watch(lastQuotesProvider(100));
    final isCalculating = ref.watch(statisticsProvider).isLoading;

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
          const SizedBox(width: 8),
          _buildStatusIcon(
            icon: isIsolateRunning ? Icons.memory : Icons.memory_outlined,
            color: isIsolateRunning ? Colors.greenAccent : Colors.redAccent,
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
                (_) => ref.read(statisticsUpdateProvider.notifier).state++,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context: context,
                    label: l10n.start,
                    isEnabled: connectionState == WebSocketState.disconnected &&
                        !isCalculating,
                    onPressed: () async {
                      ref.read(connectionStateProvider.notifier).state =
                          WebSocketState.connecting;
                      final websocketService =
                          ref.read(websocketServiceProvider);
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
                        },
                      );
                    },
                  ),
                  _buildActionButton(
                    context: context,
                    label: l10n.statistics,
                    isEnabled: connectionState != WebSocketState.disconnected &&
                        !isCalculating,
                    isLoading: isCalculating,
                    onPressed: () async {
                      final websocketService =
                          ref.read(websocketServiceProvider);
                      await websocketService.disconnect();
                      ref.read(connectionStateProvider.notifier).state =
                          WebSocketState.disconnected;
                      ref.read(statisticsUpdateProvider.notifier).state++;
                      await ref.read(statisticsProvider.future);
                    },
                  ),
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
                    child: ref.watch(statisticsProvider).when(
                          data: (statistics) => statistics != null
                              ? StatisticsTable(
                                  statistics: statistics,
                                  l10n: l10n,
                                )
                              : Center(
                                  child: Text(
                                    l10n.noDataError,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              '${l10n.error}: $error',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
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

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required bool isEnabled,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor:
              theme.colorScheme.onSurface.withOpacity(0.12),
          disabledForegroundColor:
              theme.colorScheme.onSurface.withOpacity(0.38),
          elevation: isEnabled ? 4 : 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
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
}
