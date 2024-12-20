import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics.freezed.dart';

@freezed
class Statistics with _$Statistics {
  const factory Statistics({
    required double mean,
    required double standardDeviation,
    required double mode,
    required double median,
    required int lostQuotes,
    required Duration calculationTime,
  }) = _Statistics;
}
