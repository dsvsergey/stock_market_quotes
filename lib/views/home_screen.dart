import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../l10n/app_localizations.dart';
import 'quote_chart.dart';
import 'statistics_table.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isConnected = ref.watch(websocketConnectionProvider);
    final quotesStream = ref.watch(lastQuotesProvider(100));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Icon(
            isConnected ? Icons.cloud_done : Icons.cloud_off,
            color: isConnected ? Colors.green : Colors.red,
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
                  onPressed: () async {
                    final websocketService = ref.read(websocketServiceProvider);
                    final result = await websocketService.connect();

                    result.fold(
                      (failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(failure.message)),
                        );
                        ref.read(websocketConnectionProvider.notifier).state =
                            false;
                      },
                      (_) {
                        ref.read(websocketConnectionProvider.notifier).state =
                            true;
                      },
                    );
                  },
                  child: Text(isConnected ? l10n.stop : l10n.start),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement statistics calculation
                  },
                  child: Text(l10n.statistics),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: quotesStream.when(
                    data: (quotes) => QuoteChart(
                      quotes: quotes,
                      l10n: l10n,
                    ),
                    loading: () => Center(
                      child: Text(l10n.loading),
                    ),
                    error: (error, stack) => Center(
                      child: Text('${l10n.error}: $error'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ref.watch(statisticsProvider).when(
                        data: (statistics) => StatisticsTable(
                          statistics: statistics,
                          l10n: l10n,
                        ),
                        loading: () => Center(
                          child: Text(l10n.loading),
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
