import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isConnected = ref.watch(websocketConnectionProvider);
    final quoteStream = ref.watch(quoteStreamProvider);

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
                  child: ref.watch(lastQuotesProvider(10)).when(
                        data: (quotes) {
                          if (quotes.isEmpty) {
                            return Center(
                              child: Text(l10n.loading),
                            );
                          }
                          return ListView.builder(
                            itemCount: quotes.length,
                            itemBuilder: (context, index) {
                              final quote = quotes[index];
                              return ListTile(
                                title: Text(
                                  '${l10n.lastQuote}: ${quote.value}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                subtitle: Text(
                                  'ID: ${quote.quoteId}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            },
                          );
                        },
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(l10n.statisticsTable),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
