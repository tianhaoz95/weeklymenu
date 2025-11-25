import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weeklymenu/main.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:weeklymenu/data/repositories/settings_repository.dart';
// Import UserModel
import 'package:weeklymenu/data/models/settings_model.dart'; // Import SettingsModel
import 'package:weeklymenu/presentation/screens/settings_screen.dart'; // Import SettingsScreen for Key

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // Corrected typo

  group('Settings Persistence Test', () {
    testWidgets('Selected meal types and weekdays should persist', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      ); // Increased duration

      final settingsRepository = SettingsRepository();
      final firebaseAuth = FirebaseAuth.instance;

      // Ensure no user is logged in initially, then sign up/in test user
      await firebaseAuth.signOut();
      await tester.pumpAndSettle();

      final String testEmail = 'test_settings@example.com';
      final String testPassword = 'Password123!';

      try {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );
      } catch (e) {
        // If user already exists, sign in
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          await firebaseAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          );
        } else {
          rethrow;
        }
      }

      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      ); // Added duration after login
      expect(firebaseAuth.currentUser, isNotNull);
      final userId = firebaseAuth.currentUser!.uid;

      // Clean up any previous settings for the test user
      await settingsRepository.saveSettings(
        userId,
        SettingsModel(id: userId),
      ); // Corrected parameter name

      // Assuming initial location is login, and it redirects to weekly-menu
      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      ); // Increased duration
      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      ); // Additional duration for UI to settle

      // Assert that the BottomNavigationBar is present
      expect(
        find.byType(BottomNavigationBar),
        findsOneWidget,
        reason: 'BottomNavigationBar should be present after login redirection',
      );

      // Navigate to SettingsScreen
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Ensure we are on the SettingsScreen
      expect(find.byType(SettingsScreen), findsOneWidget);

      // Find the "Breakfast" meal type FilterChip and interact with it
      final breakfastFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'Breakfast',
      );
      expect(breakfastFinder, findsOneWidget);
      FilterChip initialBreakfastChip = tester.widget(
        find.ancestor(of: breakfastFinder, matching: find.byType(FilterChip)),
      );
      final bool initialBreakfastSelected = initialBreakfastChip.selected;

      await tester.tap(
        find.ancestor(of: breakfastFinder, matching: find.byType(FilterChip)),
      );
      await tester.pumpAndSettle();

      FilterChip currentBreakfastChip = tester.widget(
        find.ancestor(of: breakfastFinder, matching: find.byType(FilterChip)),
      );
      expect(
        currentBreakfastChip.selected,
        !initialBreakfastSelected,
        reason:
            'Breakfast FilterChip should have toggled its selected state after tap',
      );

      // Find the "Monday" weekday FilterChip and interact with it
      final mondayFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == 'Monday',
      );
      expect(mondayFinder, findsOneWidget);
      FilterChip initialMondayChip = tester.widget(
        find.ancestor(of: mondayFinder, matching: find.byType(FilterChip)),
      );
      final bool initialMondaySelected = initialMondayChip.selected;

      await tester.tap(
        find.ancestor(of: mondayFinder, matching: find.byType(FilterChip)),
      );
      await tester.pumpAndSettle();

      FilterChip currentMondayChip = tester.widget(
        find.ancestor(of: mondayFinder, matching: find.byType(FilterChip)),
      );
      expect(
        currentMondayChip.selected,
        !initialMondaySelected,
        reason:
            'Monday FilterChip should have toggled its selected state after tap',
      );

      // Navigate away from SettingsScreen (e.g., to Weekly Menu)
      await tester.tap(find.byIcon(Icons.menu_book)); // Tap Weekly Menu icon
      await tester.pumpAndSettle();

      // Navigate back to SettingsScreen
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Verify persistence: Check if "Breakfast" and "Monday" selected states are persisted
      FilterChip persistedBreakfastChip = tester.widget(
        find.ancestor(of: breakfastFinder, matching: find.byType(FilterChip)),
      );
      expect(
        persistedBreakfastChip.selected,
        !initialBreakfastSelected,
        reason: 'Breakfast FilterChip should have its toggled state persisted',
      );

      FilterChip persistedMondayChip = tester.widget(
        find.ancestor(of: mondayFinder, matching: find.byType(FilterChip)),
      );
      expect(
        persistedMondayChip.selected,
        !initialMondaySelected,
        reason: 'Monday FilterChip should have its toggled state persisted',
      );

      // Clean up test user and settings
      await firebaseAuth.currentUser!.delete();
      await tester.pumpAndSettle();
    });
  });
}
