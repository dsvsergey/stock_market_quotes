import 'package:isar/isar.dart';

part 'quote.g.dart';

@collection
class Quote {
  Id id = Isar.autoIncrement;

  @Index()
  final int quoteId;
  final double value;
  final DateTime timestamp;
  bool usedInCalculation;

  Quote({
    required this.quoteId,
    required this.value,
    required this.timestamp,
    this.usedInCalculation = false,
  });
}
