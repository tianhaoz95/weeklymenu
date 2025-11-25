import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weeklymenu/presentation/view_models/locale_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleProvider', () {
    late LocaleProvider localeProvider;

    setUp(() {
      // SharedPreferences.setMockInitialValues will be called in each test
      // to ensure a clean state and specific initial values.
    });

    test('initializes with system locale if no preference is saved', () async {
      SharedPreferences.setMockInitialValues({}); // Ensure no saved value

      localeProvider = LocaleProvider();
      await localeProvider.loadLocale(); // Explicitly await loadLocale

      expect(localeProvider.locale, null);
    });

    test('loads saved locale preference correctly', () async {
      SharedPreferences.setMockInitialValues({
        LocaleProvider.localePreferenceKey: 'zh',
      });

      localeProvider = LocaleProvider();
      await localeProvider.loadLocale();
      expect(localeProvider.locale, const Locale('zh'));
    });

    test('sets new locale and saves preference', () async {
      SharedPreferences.setMockInitialValues({
        LocaleProvider.localePreferenceKey: 'en',
      }); // Initial value

      localeProvider = LocaleProvider();
      await localeProvider.loadLocale();

      await localeProvider.setLocale(const Locale('es'));
      expect(localeProvider.locale, const Locale('es'));

      final prefs = await SharedPreferences.getInstance(); // Verify directly
      expect(prefs.getString(LocaleProvider.localePreferenceKey), 'es');
    });

    test('sets system locale and saves preference', () async {
      SharedPreferences.setMockInitialValues({
        LocaleProvider.localePreferenceKey: 'fr',
      }); // Initial value

      localeProvider = LocaleProvider();
      await localeProvider.loadLocale();

      await localeProvider.setSystemLocale();
      expect(localeProvider.locale, null);

      final prefs = await SharedPreferences.getInstance(); // Verify directly
      expect(
        prefs.getString(LocaleProvider.localePreferenceKey),
        LocaleProvider.systemLocaleValue,
      );
    });

    test('notifies listeners when locale changes', () async {
      SharedPreferences.setMockInitialValues({
        LocaleProvider.localePreferenceKey: 'en',
      });

      localeProvider = LocaleProvider();
      await localeProvider.loadLocale();

      var listenerCalled = false;
      localeProvider.addListener(() {
        listenerCalled = true;
      });

      await localeProvider.setLocale(const Locale('fr'));
      expect(listenerCalled, isTrue);
    });

    testWidgets('getLocaleDisplayName returns correct value for English', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        LocaleProvider.localePreferenceKey: 'en',
      });
      localeProvider = LocaleProvider();
      await localeProvider.loadLocale(); // Load locale before pumping widget

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Text(localeProvider.getLocaleDisplayName(context));
            },
          ),
        ),
      );
      expect(find.text('en'), findsOneWidget);
    });

    testWidgets('getLocaleDisplayName returns correct value for Chinese', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        LocaleProvider.localePreferenceKey: 'zh',
      });
      localeProvider = LocaleProvider();
      await localeProvider.loadLocale(); // Load locale before pumping widget

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Text(localeProvider.getLocaleDisplayName(context));
            },
          ),
        ),
      );
      expect(find.text('zh'), findsOneWidget);
    });

    testWidgets(
      'getLocaleDisplayName returns system locale if locale is null',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          LocaleProvider.localePreferenceKey: LocaleProvider.systemLocaleValue,
        });

        localeProvider = LocaleProvider();
        await localeProvider.loadLocale(); // Load locale before pumping widget

        tester.platformDispatcher.localeTestValue = const Locale(
          'fr',
        ); // Mock system locale

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Text(localeProvider.getLocaleDisplayName(context));
              },
            ),
          ),
        );
        expect(find.text('fr'), findsOneWidget);
      },
    );
  });
}
