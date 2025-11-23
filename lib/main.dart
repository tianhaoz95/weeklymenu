import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
// Import SharedPreferences
import 'package:weeklymenu/presentation/view_models/locale_provider.dart'; // Import LocaleProvider

import 'package:weeklymenu/data/repositories/auth_repository.dart'; // Import AuthRepository
import 'package:weeklymenu/data/repositories/recipe_repository.dart'; // Import RecipeRepository
import 'package:weeklymenu/data/repositories/shopping_list_repository.dart'; // Import ShoppingListRepository
import 'package:weeklymenu/data/services/shopping_list_service.dart'; // Import ShoppingListService

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
import 'package:weeklymenu/presentation/screens/shopping_list_screen.dart'; // Import ShoppingListScreen
import 'package:weeklymenu/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:weeklymenu/data/models/recipe_model.dart'; // Import RecipeModel for extra
import 'package:weeklymenu/l10n/app_localizations.dart';

Future<void> main() async {
  // Make main async
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set the router on the authViewModel after it's been fully initialized
  _authViewModelInstance.router = _router;

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => _authRepositoryInstance,
        ), // Provide AuthRepository
        Provider<RecipeRepository>(
          create: (_) => RecipeRepository(),
        ), // Provide RecipeRepository
        Provider<ShoppingListRepository>(
          create: (_) => ShoppingListRepository(),
        ), // Provide ShoppingListRepository
        Provider<ShoppingListService>(
          create: (_) => ShoppingListService(),
        ), // Provide ShoppingListService
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => _authViewModelInstance..initialize(),
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
        ChangeNotifierProxyProvider<WeeklyMenuViewModel, ShoppingListViewModel>(
          create: (context) {
            final weeklyMenuViewModel = Provider.of<WeeklyMenuViewModel>(
              context,
              listen: false,
            );
            final authRepository = Provider.of<AuthRepository>(
              context,
              listen: false,
            ); // Retrieve AuthRepository
            final shoppingListRepository = Provider.of<ShoppingListRepository>(
              context,
              listen: false,
            ); // Retrieve ShoppingListRepository
            final shoppingListService = Provider.of<ShoppingListService>(
              context,
              listen: false,
            ); // Retrieve ShoppingListService
            final recipeRepository = Provider.of<RecipeRepository>(
              context,
              listen: false,
            ); // Retrieve RecipeRepository

            return ShoppingListViewModel(
              shoppingListRepository: shoppingListRepository,
              shoppingListService: shoppingListService,
              recipeRepository: recipeRepository,
              weeklyMenuViewModel:
                  weeklyMenuViewModel, // Pass required dependency
              authRepository: authRepository,
            )..initialize();
          },
          update: (context, weeklyMenuViewModel, previousShoppingListViewModel) {
            // No direct update needed here as ShoppingListViewModel manages its own listener.
            // It will update itself based on weeklyMenuViewModel changes.
            return previousShoppingListViewModel!;
          },
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LocaleProvider(), // Create LocaleProvider without prefs
        ),
      ],
      child: const MainApp(),
    ),
  );
}

// Create an instance of AuthRepository and AuthViewModel here to be accessible by GoRouter
final AuthRepository _authRepositoryInstance = AuthRepository();
final AuthViewModel _authViewModelInstance = AuthViewModel(
  authRepository: _authRepositoryInstance,
);

// Private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login', // Set initial location to login
  refreshListenable:
      _authViewModelInstance, // Make GoRouter react to AuthViewModel changes
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
              path: '/shopping-list',
              name: 'shopping-list', // Named route
              builder: (context, state) => const ShoppingListScreen(),
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
    final isLoggedIn = _authViewModelInstance.currentUser != null;

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
    final localeProvider = Provider.of<LocaleProvider>(
      context,
    ); // Access LocaleProvider

    final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[200], // Light grey background
        selectedItemColor: Colors.deepPurple, // Primary color for selected
        unselectedItemColor: Colors.grey[600], // Darker grey for unselected
      ),
      useMaterial3: true,
    );

    final ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[900], // Dark grey background
        selectedItemColor:
            Colors.deepPurpleAccent, // Lighter primary for selected
        unselectedItemColor: Colors.grey[400], // Lighter grey for unselected
      ),
      useMaterial3: true,
    );

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeProvider.locale, // Set app locale from LocaleProvider
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: lightTheme, // Apply light theme
      darkTheme: darkTheme, // Apply dark theme
    );
  }
}
