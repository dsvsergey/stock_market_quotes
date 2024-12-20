import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(websocketConnectionProvider);
    final quoteStream = ref.watch(quoteStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Statistics'),
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
                  child: Text(isConnected ? 'Стоп' : 'Старт'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement statistics calculation
                  },
                  child: const Text('Статистика'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: quoteStream.when(
                    data: (quote) => Center(
                      child: Text(
                        'Останнє котирування: ${quote.value}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Помилка: $error'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Тут буде таблиця статистики'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
