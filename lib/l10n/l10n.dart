import 'package:flutter/material.dart';

import 'generated/app.translation.g.dart';

class S {
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations.of(context) ??
        lookupAppLocalizations(const Locale('zh'));
  }

  static List<LocalizationsDelegate> get localizationsDelegates =>
      AppLocalizations.localizationsDelegates;

  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  static LocalizationsDelegate<AppLocalizations> get delegate =>
      AppLocalizations.delegate;

  static String getlang(BuildContext context, String? localeCode) {
    switch (localeCode) {
      case 'zh':
        return '简体中文';
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      default:
        return of(context).followSystem;
    }
  }
}

extension L10nX on BuildContext {
  AppLocalizations get tr => S.of(this);

  MaterialLocalizations get mtr => MaterialLocalizations.of(this);
}
