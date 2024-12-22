// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStatisticsCollection on Isar {
  IsarCollection<Statistics> get statistics => this.collection();
}

const StatisticsSchema = CollectionSchema(
  name: r'Statistics',
  id: -3012562703602652036,
  properties: {
    r'calculatedAt': PropertySchema(
      id: 0,
      name: r'calculatedAt',
      type: IsarType.dateTime,
    ),
    r'calculationTimeMs': PropertySchema(
      id: 1,
      name: r'calculationTimeMs',
      type: IsarType.long,
    ),
    r'lostQuotes': PropertySchema(
      id: 2,
      name: r'lostQuotes',
      type: IsarType.long,
    ),
    r'mean': PropertySchema(
      id: 3,
      name: r'mean',
      type: IsarType.double,
    ),
    r'median': PropertySchema(
      id: 4,
      name: r'median',
      type: IsarType.double,
    ),
    r'mode': PropertySchema(
      id: 5,
      name: r'mode',
      type: IsarType.double,
    ),
    r'standardDeviation': PropertySchema(
      id: 6,
      name: r'standardDeviation',
      type: IsarType.double,
    )
  },
  estimateSize: _statisticsEstimateSize,
  serialize: _statisticsSerialize,
  deserialize: _statisticsDeserialize,
  deserializeProp: _statisticsDeserializeProp,
  idName: r'id',
  indexes: {
    r'calculatedAt': IndexSchema(
      id: -1800937546775664298,
      name: r'calculatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'calculatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _statisticsGetId,
  getLinks: _statisticsGetLinks,
  attach: _statisticsAttach,
  version: '3.1.0+1',
);

int _statisticsEstimateSize(
  Statistics object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _statisticsSerialize(
  Statistics object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.calculatedAt);
  writer.writeLong(offsets[1], object.calculationTimeMs);
  writer.writeLong(offsets[2], object.lostQuotes);
  writer.writeDouble(offsets[3], object.mean);
  writer.writeDouble(offsets[4], object.median);
  writer.writeDouble(offsets[5], object.mode);
  writer.writeDouble(offsets[6], object.standardDeviation);
}

Statistics _statisticsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Statistics(
    calculatedAt: reader.readDateTime(offsets[0]),
    calculationTimeMs: reader.readLong(offsets[1]),
    lostQuotes: reader.readLong(offsets[2]),
    mean: reader.readDouble(offsets[3]),
    median: reader.readDouble(offsets[4]),
    mode: reader.readDouble(offsets[5]),
    standardDeviation: reader.readDouble(offsets[6]),
  );
  object.id = id;
  return object;
}

P _statisticsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _statisticsGetId(Statistics object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _statisticsGetLinks(Statistics object) {
  return [];
}

void _statisticsAttach(IsarCollection<dynamic> col, Id id, Statistics object) {
  object.id = id;
}

extension StatisticsQueryWhereSort
    on QueryBuilder<Statistics, Statistics, QWhere> {
  QueryBuilder<Statistics, Statistics, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhere> anyCalculatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'calculatedAt'),
      );
    });
  }
}

extension StatisticsQueryWhere
    on QueryBuilder<Statistics, Statistics, QWhereClause> {
  QueryBuilder<Statistics, Statistics, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> calculatedAtEqualTo(
      DateTime calculatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'calculatedAt',
        value: [calculatedAt],
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause>
      calculatedAtNotEqualTo(DateTime calculatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'calculatedAt',
              lower: [],
              upper: [calculatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'calculatedAt',
              lower: [calculatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'calculatedAt',
              lower: [calculatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'calculatedAt',
              lower: [],
              upper: [calculatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause>
      calculatedAtGreaterThan(
    DateTime calculatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'calculatedAt',
        lower: [calculatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> calculatedAtLessThan(
    DateTime calculatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'calculatedAt',
        lower: [],
        upper: [calculatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterWhereClause> calculatedAtBetween(
    DateTime lowerCalculatedAt,
    DateTime upperCalculatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'calculatedAt',
        lower: [lowerCalculatedAt],
        includeLower: includeLower,
        upper: [upperCalculatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StatisticsQueryFilter
    on QueryBuilder<Statistics, Statistics, QFilterCondition> {
  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      calculatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calculatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      calculatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calculatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      calculatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calculatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      calculatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calculatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      calculationTimeMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calculationTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      calculationTimeMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calculationTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      calculationTimeMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calculationTimeMs',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      calculationTimeMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calculationTimeMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> lostQuotesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lostQuotes',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      lostQuotesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lostQuotes',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      lostQuotesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lostQuotes',
        value: value,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> lostQuotesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lostQuotes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> meanEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mean',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> meanGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mean',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> meanLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mean',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> meanBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mean',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> medianEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'median',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> medianGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'median',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> medianLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'median',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> medianBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'median',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> modeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mode',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> modeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mode',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> modeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mode',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition> modeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      standardDeviationEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'standardDeviation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      standardDeviationGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'standardDeviation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      standardDeviationLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'standardDeviation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterFilterCondition>
      standardDeviationBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'standardDeviation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension StatisticsQueryObject
    on QueryBuilder<Statistics, Statistics, QFilterCondition> {}

extension StatisticsQueryLinks
    on QueryBuilder<Statistics, Statistics, QFilterCondition> {}

extension StatisticsQuerySortBy
    on QueryBuilder<Statistics, Statistics, QSortBy> {
  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByCalculatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculatedAt', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByCalculatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculatedAt', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByCalculationTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationTimeMs', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy>
      sortByCalculationTimeMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationTimeMs', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByLostQuotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lostQuotes', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByLostQuotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lostQuotes', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByMean() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mean', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByMeanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mean', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByMedian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'median', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByMedianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'median', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> sortByStandardDeviation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardDeviation', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy>
      sortByStandardDeviationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardDeviation', Sort.desc);
    });
  }
}

extension StatisticsQuerySortThenBy
    on QueryBuilder<Statistics, Statistics, QSortThenBy> {
  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByCalculatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculatedAt', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByCalculatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculatedAt', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByCalculationTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationTimeMs', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy>
      thenByCalculationTimeMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationTimeMs', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByLostQuotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lostQuotes', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByLostQuotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lostQuotes', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByMean() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mean', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByMeanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mean', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByMedian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'median', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByMedianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'median', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy> thenByStandardDeviation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardDeviation', Sort.asc);
    });
  }

  QueryBuilder<Statistics, Statistics, QAfterSortBy>
      thenByStandardDeviationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'standardDeviation', Sort.desc);
    });
  }
}

extension StatisticsQueryWhereDistinct
    on QueryBuilder<Statistics, Statistics, QDistinct> {
  QueryBuilder<Statistics, Statistics, QDistinct> distinctByCalculatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calculatedAt');
    });
  }

  QueryBuilder<Statistics, Statistics, QDistinct>
      distinctByCalculationTimeMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calculationTimeMs');
    });
  }

  QueryBuilder<Statistics, Statistics, QDistinct> distinctByLostQuotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lostQuotes');
    });
  }

  QueryBuilder<Statistics, Statistics, QDistinct> distinctByMean() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mean');
    });
  }

  QueryBuilder<Statistics, Statistics, QDistinct> distinctByMedian() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'median');
    });
  }

  QueryBuilder<Statistics, Statistics, QDistinct> distinctByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mode');
    });
  }

  QueryBuilder<Statistics, Statistics, QDistinct>
      distinctByStandardDeviation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'standardDeviation');
    });
  }
}

extension StatisticsQueryProperty
    on QueryBuilder<Statistics, Statistics, QQueryProperty> {
  QueryBuilder<Statistics, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Statistics, DateTime, QQueryOperations> calculatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calculatedAt');
    });
  }

  QueryBuilder<Statistics, int, QQueryOperations> calculationTimeMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calculationTimeMs');
    });
  }

  QueryBuilder<Statistics, int, QQueryOperations> lostQuotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lostQuotes');
    });
  }

  QueryBuilder<Statistics, double, QQueryOperations> meanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mean');
    });
  }

  QueryBuilder<Statistics, double, QQueryOperations> medianProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'median');
    });
  }

  QueryBuilder<Statistics, double, QQueryOperations> modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mode');
    });
  }

  QueryBuilder<Statistics, double, QQueryOperations>
      standardDeviationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'standardDeviation');
    });
  }
}
