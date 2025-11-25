import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';
import 'package:weeklymenu/presentation/view_models/locale_provider.dart';

class LanguageDropdownWidget extends StatelessWidget {
  const LanguageDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    // Get current locale display name or 'System Default'
    String currentLocaleDisplayName;
    if (localeProvider.locale == null) {
      currentLocaleDisplayName = appLocalizations.systemDefault;
    } else if (localeProvider.locale!.languageCode == 'en') {
      currentLocaleDisplayName = appLocalizations.english;
    } else if (localeProvider.locale!.languageCode == 'zh') {
      currentLocaleDisplayName = appLocalizations.chinese;
    } else {
      currentLocaleDisplayName =
          localeProvider.locale!.languageCode; // Fallback
    }

    return DropdownButton<String>(
      value: currentLocaleDisplayName,
      onChanged: (String? newValue) {
        if (newValue != null) {
          if (newValue == appLocalizations.english) {
            localeProvider.setLocale(const Locale('en'));
          } else if (newValue == appLocalizations.chinese) {
            localeProvider.setLocale(const Locale('zh'));
          } else if (newValue == appLocalizations.systemDefault) {
            localeProvider.setSystemLocale();
          }
        }
      },
      items:
          <String>[
            appLocalizations.english,
            appLocalizations.chinese,
            appLocalizations.systemDefault,
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
    );
  }
}
