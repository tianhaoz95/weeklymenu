import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weeklymenu/main.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weeklymenu/data/repositories/settings_repository.dart';
import 'package:weeklymenu/data/models/settings_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bottom Navigator Order Test', () {
    final String testEmail = 'test_nav_order@example.com';
    final String testPassword = 'Password123!';
    late String userId;

    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final firebaseAuth = FirebaseAuth.instance;
      final settingsRepository = SettingsRepository();

      await firebaseAuth.signOut();

      try {
        await firebaseAuth.createUserWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );
      } catch (e) {
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          await firebaseAuth.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          );
        } else {
          rethrow;
        }
      }
      userId = firebaseAuth.currentUser!.uid;

      // Ensure user has some default settings
      await settingsRepository.saveSettings(userId, SettingsModel(id: userId));
    });

    tearDownAll(() async {
      await Firebase.initializeApp();
      final firebaseAuth = FirebaseAuth.instance;
      // Delete test user
      await firebaseAuth.currentUser?.delete();
    });

    testWidgets('Bottom navigation items should be in the correct order', (
      WidgetTester tester,
    ) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Assert that the BottomNavigationBar is present
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify the order of items by their icons and labels
      final Finder weeklyMenuFinder = find.byIcon(Icons.menu_book);
      final Finder shoppingListFinder = find.byIcon(Icons.shopping_cart);
      final Finder cookbookFinder = find.byIcon(Icons.restaurant_menu);
      final Finder settingsFinder = find.byIcon(Icons.settings);

      // Expect all icons to be present
      expect(weeklyMenuFinder, findsOneWidget);
      expect(shoppingListFinder, findsOneWidget);
      expect(cookbookFinder, findsOneWidget);
      expect(settingsFinder, findsOneWidget);

      // Get the positions of the icons
      final Offset weeklyMenuPos = tester.getCenter(weeklyMenuFinder);
      final Offset shoppingListPos = tester.getCenter(shoppingListFinder);
      final Offset cookbookPos = tester.getCenter(cookbookFinder);
      final Offset settingsPos = tester.getCenter(settingsFinder);

      // Assert the order from left to right based on x-coordinate
      expect(
        weeklyMenuPos.dx,
        lessThan(shoppingListPos.dx),
        reason: 'Weekly Menu should be to the left of Shopping List',
      );
      expect(
        shoppingListPos.dx,
        lessThan(cookbookPos.dx),
        reason: 'Shopping List should be to the left of Cookbook',
      );
      expect(
        cookbookPos.dx,
        lessThan(settingsPos.dx),
        reason: 'Cookbook should be to the left of Settings',
      );
    });
  });
}
