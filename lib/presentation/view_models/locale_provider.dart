import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  // Key for storing locale preference in shared preferences
  static const String localePreferenceKey = 'locale_preference';
  static const String systemLocaleValue = 'system';

  late SharedPreferences _prefs; // Make it late to initialize in _loadLocale

  LocaleProvider() {
    loadLocale();
  }

  Future<void> loadLocale() async {
    _prefs = await SharedPreferences.getInstance();
    final String? languageCode = _prefs.getString(localePreferenceKey);

    if (languageCode != null && languageCode != systemLocaleValue) {
      _locale = Locale(languageCode);
    } else if (languageCode == systemLocaleValue) {
      _locale = null; // Use system default
    } else {
      // Default to system locale if no preference is found
      _locale = null;
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    await _prefs.setString(localePreferenceKey, newLocale.languageCode);
    notifyListeners();
  }

  Future<void> setSystemLocale() async {
    if (_locale == null) return; // Already using system locale
    _locale = null;
    await _prefs.setString(localePreferenceKey, systemLocaleValue);
    notifyListeners();
  }

  // Helper to get the display name for the current locale or system default
  String getLocaleDisplayName(BuildContext context) {
    if (_locale == null) {
      return WidgetsBinding
          .instance
          .platformDispatcher
          .locale
          .languageCode; // Fallback to system language name
    }
    return _locale!.languageCode;
  }
}
