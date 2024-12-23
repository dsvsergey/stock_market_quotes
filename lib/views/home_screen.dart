import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../l10n/app_localizations.dart';
import 'statistics_table.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isConnected = ref.watch(websocketConnectionProvider);
    final isIsolateRunning = ref.watch(websocketIsolateProvider).value ?? false;
    final quotesStream = ref.watch(lastQuotesProvider(100));
    final isCalculating = ref.watch(statisticsProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Icon(
            isConnected ? Icons.cloud_done : Icons.cloud_off,
            color: isConnected ? Colors.green : Colors.red,
          ),
          Icon(
            isIsolateRunning ? Icons.memory : Icons.memory_outlined,
            color: isIsolateRunning ? Colors.green : Colors.red,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final databaseService = ref.read(databaseServiceProvider);
              final result = await databaseService.clearAllQuotes();
              result.fold(
                (failure) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(failure.message)),
                ),
                (_) => ref.read(statisticsUpdateProvider.notifier).state++,
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isConnected || isCalculating
                      ? null
                      : () async {
                          final websocketService =
                              ref.read(websocketServiceProvider);
                          final result = await websocketService.connect();
                          result.fold(
                            (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(failure.message)),
                              );
                              ref
                                  .read(websocketConnectionProvider.notifier)
                                  .state = false;
                            },
                            (_) {
                              ref
                                  .read(websocketConnectionProvider.notifier)
                                  .state = true;
                            },
                          );
                        },
                  child: Text(l10n.start),
                ),
                ElevatedButton(
                  onPressed: !isConnected || isCalculating
                      ? null
                      : () async {
                          final websocketService =
                              ref.read(websocketServiceProvider);
                          await websocketService.disconnect();
                          ref.read(websocketConnectionProvider.notifier).state =
                              false;

                          // Спочатку оновлюємо статистику
                          ref.read(statisticsUpdateProvider.notifier).state++;

                          // Чекаємо завершення розрахунків
                          await ref.read(statisticsProvider.future);
                        },
                  child: isCalculating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(l10n.statistics),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ref.watch(statisticsProvider).when(
                        data: (statistics) => statistics != null
                            ? StatisticsTable(
                                statistics: statistics,
                                l10n: l10n,
                              )
                            : Center(child: Text(l10n.noDataError)),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stack) => Center(
                          child: Text('${l10n.error}: $error'),
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
