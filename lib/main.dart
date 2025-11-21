import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';
import 'package:weeklymenu/presentation/view_models/settings_view_model.dart';
import 'package:weeklymenu/presentation/view_models/cookbook_view_model.dart';
import 'package:weeklymenu/presentation/view_models/weekly_menu_view_model.dart';
import 'package:weeklymenu/presentation/view_models/shopping_list_view_model.dart';
import 'package:weeklymenu/presentation/screens/login_screen.dart';
import 'package:weeklymenu/presentation/screens/signup_screen.dart';
import 'package:weeklymenu/presentation/screens/forgot_password_screen.dart';
import 'package:weeklymenu/presentation/screens/weekly_menu_screen.dart';
import 'package:weeklymenu/presentation/screens/cookbook_screen.dart';
import 'package:weeklymenu/presentation/screens/settings_screen.dart';
import 'package:weeklymenu/presentation/screens/recipe_screen.dart'; // Import RecipeScreen
import 'package:weeklymenu/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:weeklymenu/data/models/recipe_model.dart'; // Import RecipeModel for extra
import 'package:weeklymenu/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewModel()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsViewModel()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => CookbookViewModel()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => WeeklyMenuViewModel()..initialize(),
        ),
        ChangeNotifierProvider(create: (context) => ShoppingListViewModel()),
      ],
      child: const MainApp(),
    ),
  );
}

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login', // Set initial location to login
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    // StatefulShellRoute for bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/weekly-menu',
              name: 'weekly-menu', // Named route
              builder: (context, state) => ChangeNotifierProvider.value(
                value: Provider.of<WeeklyMenuViewModel>(context),
                child: const WeeklyMenuScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cookbook',
              name: 'cookbook', // Named route
              builder: (context, state) => const CookbookScreen(),
              routes: [
                GoRoute(
                  path: 'recipe-detail/:id', // Relative path to /cookbook
                  name: 'recipe-detail', // Named route for recipe details
                  builder: (context, state) {
                    final recipe = state.extra as RecipeModel?;
                    final recipeId = state.pathParameters['id'];
                    return RecipeScreen(recipe: recipe, recipeId: recipeId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: 'settings', // Named route
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final isLoggedIn = authViewModel.currentUser != null;

    final isLoggingIn = state.matchedLocation == '/login';
    final isSigningUp = state.matchedLocation == '/signup';
    final isForgotPassword = state.matchedLocation == '/forgot-password';

    if (!isLoggedIn && !(isLoggingIn || isSigningUp || isForgotPassword)) {
      return '/login';
    }
    if (isLoggedIn && (isLoggingIn || isSigningUp || isForgotPassword)) {
      return '/weekly-menu'; // Redirect to main authenticated route
    }

    return null;
  },
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    );
  }
}
