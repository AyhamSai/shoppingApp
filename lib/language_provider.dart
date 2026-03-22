import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale currentLocale = Locale('en');

  Locale getcurrentLocale() => currentLocale;

  void changLanguage(String langCode) {
    currentLocale = Locale(langCode);
    notifyListeners();
  }

  String translate(String arText, String enText) {
    return currentLocale.languageCode == 'ar' ? arText : enText;
  }
}
