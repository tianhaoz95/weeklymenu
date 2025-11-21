import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklymenu/main.dart' as app;
import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';
import 'package:weeklymenu/presentation/screens/weekly_menu_screen.dart'; // Import WeeklyMenuScreen
import 'package:weeklymenu/l10n/app_localizations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login and Navigation Integration Test', () {
    testWidgets('Login with test credentials and verify navigation to WeeklyMenuScreen', (WidgetTester tester) async {
      // Ensure environment variables are set
      const testEmail = String.fromEnvironment('TEST_EMAIL');
      const testPassword = String.fromEnvironment('TEST_PASSWORD');

      expect(testEmail, isNotEmpty, reason: 'TEST_EMAIL environment variable must be set');
      expect(testPassword, isNotEmpty, reason: 'TEST_PASSWORD environment variable must be set');

      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find the email and password input fields
      final emailField = find.byKey(const Key('email_input_field'));
      final passwordField = find.byKey(const Key('password_input_field'));
      final loginButton = find.byKey(const Key('login_button'));

      // If the email and password fields are not found, it means the app is not on the login screen
      // This might happen if the user was already logged in or if the initial route changed.
      // We need to ensure we are on the login screen if not already there.
      // For now, let's assume the app starts on the login screen as per initialRoute: '/login' in main.dart

      // Enter test credentials
      await tester.enterText(emailField, testEmail);
      await tester.enterText(passwordField, testPassword);
      await tester.pumpAndSettle();

      // Tap the login button
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify that we are on the WeeklyMenuScreen
      // This assertion will pass if WeeklyMenuScreen is present in the widget tree
      expect(find.byType(WeeklyMenuScreen), findsOneWidget);

      // Optionally, verify some text on the WeeklyMenuScreen to be more robust
      // Replace with actual text found on your WeeklyMenuScreen
      // final appLocalizations = await AppLocalizations.delegate.load(const Locale('en', ''));
      // expect(find.text(appLocalizations.weeklyMenuTitle), findsOneWidget);
    });
  });
}
