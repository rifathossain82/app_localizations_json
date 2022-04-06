import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations{
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }


  static const LocalizationsDelegate<AppLocalizations> delegate= _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async{
    String jsonString=await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    _localizedStrings = jsonMap.map((key, value){
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String? translate(String key){
    return _localizedStrings![key];
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations>{

  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'bn', 'hi', 'ar', 'ms'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async{
    AppLocalizations localizations=AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) {
    return false;
  }

}