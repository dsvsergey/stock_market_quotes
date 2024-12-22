import 'package:isar/isar.dart';

part 'statistics.g.dart';

@collection
class Statistics {
  Id id = Isar.autoIncrement;

  final double mean;
  final double standardDeviation;
  final double mode;
  final double median;
  final int lostQuotes;
  @Index()
  final DateTime calculatedAt;
  final int calculationTimeMs;

  Statistics({
    required this.mean,
    required this.standardDeviation,
    required this.mode,
    required this.median,
    required this.lostQuotes,
    required this.calculationTimeMs,
    required this.calculatedAt,
  });

  factory Statistics.create({
    required double mean,
    required double standardDeviation,
    required double mode,
    required double median,
    required int lostQuotes,
    required Duration calculationTime,
  }) {
    return Statistics(
      mean: mean,
      standardDeviation: standardDeviation,
      mode: mode,
      median: median,
      lostQuotes: lostQuotes,
      calculationTimeMs: calculationTime.inMilliseconds,
      calculatedAt: DateTime.now(),
    );
  }

  @ignore
  Duration get calculationTime => Duration(milliseconds: calculationTimeMs);

  Statistics copyWith({
    double? mean,
    double? standardDeviation,
    double? mode,
    double? median,
    int? lostQuotes,
    Duration? calculationTime,
    DateTime? calculatedAt,
  }) {
    return Statistics(
      mean: mean ?? this.mean,
      standardDeviation: standardDeviation ?? this.standardDeviation,
      mode: mode ?? this.mode,
      median: median ?? this.median,
      lostQuotes: lostQuotes ?? this.lostQuotes,
      calculationTimeMs: calculationTime?.inMilliseconds ?? calculationTimeMs,
      calculatedAt: calculatedAt ?? this.calculatedAt,
    );
  }
}
