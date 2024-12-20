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
}
