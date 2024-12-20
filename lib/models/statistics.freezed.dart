// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Statistics {
  double get mean => throw _privateConstructorUsedError;
  double get standardDeviation => throw _privateConstructorUsedError;
  double get mode => throw _privateConstructorUsedError;
  double get median => throw _privateConstructorUsedError;
  int get lostQuotes => throw _privateConstructorUsedError;
  Duration get calculationTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $StatisticsCopyWith<Statistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsCopyWith<$Res> {
  factory $StatisticsCopyWith(
          Statistics value, $Res Function(Statistics) then) =
      _$StatisticsCopyWithImpl<$Res, Statistics>;
  @useResult
  $Res call(
      {double mean,
      double standardDeviation,
      double mode,
      double median,
      int lostQuotes,
      Duration calculationTime});
}

/// @nodoc
class _$StatisticsCopyWithImpl<$Res, $Val extends Statistics>
    implements $StatisticsCopyWith<$Res> {
  _$StatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mean = null,
    Object? standardDeviation = null,
    Object? mode = null,
    Object? median = null,
    Object? lostQuotes = null,
    Object? calculationTime = null,
  }) {
    return _then(_value.copyWith(
      mean: null == mean
          ? _value.mean
          : mean // ignore: cast_nullable_to_non_nullable
              as double,
      standardDeviation: null == standardDeviation
          ? _value.standardDeviation
          : standardDeviation // ignore: cast_nullable_to_non_nullable
              as double,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as double,
      median: null == median
          ? _value.median
          : median // ignore: cast_nullable_to_non_nullable
              as double,
      lostQuotes: null == lostQuotes
          ? _value.lostQuotes
          : lostQuotes // ignore: cast_nullable_to_non_nullable
              as int,
      calculationTime: null == calculationTime
          ? _value.calculationTime
          : calculationTime // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatisticsImplCopyWith<$Res>
    implements $StatisticsCopyWith<$Res> {
  factory _$$StatisticsImplCopyWith(
          _$StatisticsImpl value, $Res Function(_$StatisticsImpl) then) =
      __$$StatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double mean,
      double standardDeviation,
      double mode,
      double median,
      int lostQuotes,
      Duration calculationTime});
}

/// @nodoc
class __$$StatisticsImplCopyWithImpl<$Res>
    extends _$StatisticsCopyWithImpl<$Res, _$StatisticsImpl>
    implements _$$StatisticsImplCopyWith<$Res> {
  __$$StatisticsImplCopyWithImpl(
      _$StatisticsImpl _value, $Res Function(_$StatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mean = null,
    Object? standardDeviation = null,
    Object? mode = null,
    Object? median = null,
    Object? lostQuotes = null,
    Object? calculationTime = null,
  }) {
    return _then(_$StatisticsImpl(
      mean: null == mean
          ? _value.mean
          : mean // ignore: cast_nullable_to_non_nullable
              as double,
      standardDeviation: null == standardDeviation
          ? _value.standardDeviation
          : standardDeviation // ignore: cast_nullable_to_non_nullable
              as double,
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as double,
      median: null == median
          ? _value.median
          : median // ignore: cast_nullable_to_non_nullable
              as double,
      lostQuotes: null == lostQuotes
          ? _value.lostQuotes
          : lostQuotes // ignore: cast_nullable_to_non_nullable
              as int,
      calculationTime: null == calculationTime
          ? _value.calculationTime
          : calculationTime // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc

class _$StatisticsImpl implements _Statistics {
  const _$StatisticsImpl(
      {required this.mean,
      required this.standardDeviation,
      required this.mode,
      required this.median,
      required this.lostQuotes,
      required this.calculationTime});

  @override
  final double mean;
  @override
  final double standardDeviation;
  @override
  final double mode;
  @override
  final double median;
  @override
  final int lostQuotes;
  @override
  final Duration calculationTime;

  @override
  String toString() {
    return 'Statistics(mean: $mean, standardDeviation: $standardDeviation, mode: $mode, median: $median, lostQuotes: $lostQuotes, calculationTime: $calculationTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsImpl &&
            (identical(other.mean, mean) || other.mean == mean) &&
            (identical(other.standardDeviation, standardDeviation) ||
                other.standardDeviation == standardDeviation) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.median, median) || other.median == median) &&
            (identical(other.lostQuotes, lostQuotes) ||
                other.lostQuotes == lostQuotes) &&
            (identical(other.calculationTime, calculationTime) ||
                other.calculationTime == calculationTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mean, standardDeviation, mode,
      median, lostQuotes, calculationTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsImplCopyWith<_$StatisticsImpl> get copyWith =>
      __$$StatisticsImplCopyWithImpl<_$StatisticsImpl>(this, _$identity);
}

abstract class _Statistics implements Statistics {
  const factory _Statistics(
      {required final double mean,
      required final double standardDeviation,
      required final double mode,
      required final double median,
      required final int lostQuotes,
      required final Duration calculationTime}) = _$StatisticsImpl;

  @override
  double get mean;
  @override
  double get standardDeviation;
  @override
  double get mode;
  @override
  double get median;
  @override
  int get lostQuotes;
  @override
  Duration get calculationTime;
  @override
  @JsonKey(ignore: true)
  _$$StatisticsImplCopyWith<_$StatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
