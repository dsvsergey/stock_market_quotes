import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = {
    'uk': {
      'appTitle': 'Торгова Статистика',
      'start': 'Старт',
      'stop': 'Стоп',
      'statistics': 'Статистика',
      'lastQuote': 'Останнє котирування',
      'connectionError': 'Помилка підключення до WebSocket',
      'parsingError': 'Помилка парсингу даних',
      'connectionClosed': 'WebSocket з\'єднання закрито',
      'statisticsTable': 'Таблиця статистики',
      'loading': 'Завантаження...',
      'error': 'Помилка',
      'mean': 'Середнє',
      'standardDeviation': 'Стандартне відхилення',
      'mode': 'Мода',
      'median': 'Медіана',
      'lostQuotes': 'Втрачені котирування',
      'calculationTime': 'Ча обчислення',
      'milliseconds': 'мс',
      'noDataError': 'Немає даних для обчислення',
      'statisticsError': 'Помилка обчислення статистики',
      'saveError': 'Помилка збереження',
      'parsingDataError': 'Помилка парсингу даних',
      'websocketError': 'Помилка WebSocket',
      'connectionClosedMessage': 'WebSocket з\'єднання закрито',
      'databaseClearError': 'Помилка очищення бази даних',
    },
    'en': {
      'appTitle': 'Trade Statistics',
      'start': 'Start',
      'stop': 'Stop',
      'statistics': 'Statistics',
      'lastQuote': 'Last Quote',
      'connectionError': 'WebSocket connection error',
      'parsingError': 'Data parsing error',
      'connectionClosed': 'WebSocket connection closed',
      'statisticsTable': 'Statistics Table',
      'loading': 'Loading...',
      'error': 'Error',
      'mean': 'Mean',
      'standardDeviation': 'Standard Deviation',
      'mode': 'Mode',
      'median': 'Median',
      'lostQuotes': 'Lost Quotes',
      'calculationTime': 'Calculation Time',
      'milliseconds': 'ms',
      'noDataError': 'No data available for calculation',
      'statisticsError': 'Statistics calculation error',
      'saveError': 'Save error',
      'parsingDataError': 'Data parsing error',
      'websocketError': 'WebSocket error',
      'connectionClosedMessage': 'WebSocket connection closed',
      'databaseClearError': 'Database clearing error',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get start => _localizedValues[locale.languageCode]!['start']!;
  String get stop => _localizedValues[locale.languageCode]!['stop']!;
  String get statistics =>
      _localizedValues[locale.languageCode]!['statistics']!;
  String get lastQuote => _localizedValues[locale.languageCode]!['lastQuote']!;
  String get connectionError =>
      _localizedValues[locale.languageCode]!['connectionError']!;
  String get parsingError =>
      _localizedValues[locale.languageCode]!['parsingError']!;
  String get connectionClosed =>
      _localizedValues[locale.languageCode]!['connectionClosed']!;
  String get statisticsTable =>
      _localizedValues[locale.languageCode]!['statisticsTable']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get mean => _localizedValues[locale.languageCode]!['mean']!;
  String get standardDeviation =>
      _localizedValues[locale.languageCode]!['standardDeviation']!;
  String get mode => _localizedValues[locale.languageCode]!['mode']!;
  String get median => _localizedValues[locale.languageCode]!['median']!;
  String get lostQuotes =>
      _localizedValues[locale.languageCode]!['lostQuotes']!;
  String get calculationTime =>
      _localizedValues[locale.languageCode]!['calculationTime']!;
  String get milliseconds =>
      _localizedValues[locale.languageCode]!['milliseconds']!;
  String get noDataError =>
      _localizedValues[locale.languageCode]!['noDataError']!;
  String get statisticsError =>
      _localizedValues[locale.languageCode]!['statisticsError']!;
  String get saveError => _localizedValues[locale.languageCode]!['saveError']!;
  String get parsingDataError =>
      _localizedValues[locale.languageCode]!['parsingDataError']!;
  String get websocketError =>
      _localizedValues[locale.languageCode]!['websocketError']!;
  String get connectionClosedMessage =>
      _localizedValues[locale.languageCode]!['connectionClosedMessage']!;
  String get databaseClearError =>
      _localizedValues[locale.languageCode]!['databaseClearError']!;
}
