import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dartz/dartz.dart';
import '../models/quote.dart';

class DatabaseFailure {
  final String message;
  DatabaseFailure(this.message);
}

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [QuoteSchema],
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
      return left(DatabaseFailure('Помилка збереження котирування: $e'));
    }
  }

  Future<Either<DatabaseFailure, List<Quote>>> getAllQuotes() async {
    try {
      final isar = await db;
      final quotes = await isar.quotes.where().findAll();
      return right(quotes);
    } catch (e) {
      return left(DatabaseFailure('Помилка отримання котирувань: $e'));
    }
  }

  Stream<List<Quote>> watchQuotes() async* {
    final isar = await db;
    yield* isar.quotes.where().watch(fireImmediately: true);
  }

  Future<Either<DatabaseFailure, void>> clearAllQuotes() async {
    try {
      final isar = await db;
      await isar.writeTxn(() async {
        await isar.quotes.clear();
      });
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure('Помилка общения бази даних: $e'));
    }
  }
}
