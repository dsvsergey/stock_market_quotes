import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dartz/dartz.dart';
import '../models/quote.dart';
import '../models/statistics.dart';
import '../l10n/app_localizations.dart';

class DatabaseFailure {
  final String message;
  DatabaseFailure(this.message);
}

class DatabaseService {
  late Future<Isar> db;
  final AppLocalizations l10n;

  DatabaseService(this.l10n) {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [QuoteSchema, StatisticsSchema],
      directory: dir.path,
    );
  }

  Future<Either<DatabaseFailure, Unit>> saveQuote(Quote quote) async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.quotes.put(quote);
      });
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure('${l10n.saveError}: $e'));
    }
  }

  Future<Either<DatabaseFailure, Unit>> updateQuote(Quote quote) async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.quotes.put(quote);
      });
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure('${l10n.updateError}: $e'));
    }
  }

  Future<Either<DatabaseFailure, Unit>> saveStatistics(
      Statistics statistics) async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.statistics.put(statistics);
      });
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure('${l10n.saveError}: $e'));
    }
  }

  Future<Either<DatabaseFailure, Statistics?>> getLastStatistics() async {
    try {
      final isar = await db;
      final statistics =
          await isar.statistics.where().sortByCalculatedAtDesc().findFirst();
      return right(statistics);
    } catch (e) {
      return left(DatabaseFailure('${l10n.getQuotesError}: $e'));
    }
  }

  Future<Either<DatabaseFailure, List<Quote>>> getLastQuotes(int limit) async {
    try {
      final isar = await db;
      final quotes = await isar.quotes
          .where()
          .sortByTimestampDesc()
          .limit(limit)
          .findAll();
      return right(quotes);
    } catch (e) {
      return left(DatabaseFailure('${l10n.getQuotesError}: $e'));
    }
  }

  Stream<List<Quote>> watchQuotes() async* {
    final isar = await db;
    yield* isar.quotes.where().watch(fireImmediately: true);
  }

  Future<Either<DatabaseFailure, Unit>> clearAllQuotes() async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.quotes.clear();
        await isar.statistics.clear();
      });
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure('${l10n.clearError}: $e'));
    }
  }
}
