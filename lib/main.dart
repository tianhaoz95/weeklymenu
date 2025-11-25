import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklymenu/presentation/view_models/locale_provider.dart';
import 'package:weeklymenu/data/repositories/auth_repository.dart';
import 'package:weeklymenu/data/repositories/recipe_repository.dart';
import 'package:weeklymenu/data/repositories/shopping_list_repository.dart';
import 'package:weeklymenu/data/services/shopping_list_service.dart';
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
import 'package:weeklymenu/presentation/screens/recipe_screen.dart';
import 'package:weeklymenu/presentation/screens/shopping_list_screen.dart';
import 'package:weeklymenu/presentation/widgets/scaffold_with_nav_bar.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';
import 'package:weeklymenu/presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _authViewModelInstance.router = _router;

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => _authRepositoryInstance),
        Provider<RecipeRepository>(create: (_) => RecipeRepository()),
        Provider<ShoppingListRepository>(
          create: (_) => ShoppingListRepository(),
        ),
        Provider<ShoppingListService>(create: (_) => ShoppingListService()),
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
        ChangeNotifierProvider(
          create: (context) {
            final weeklyMenuViewModel = Provider.of<WeeklyMenuViewModel>(
              context,
              listen: false,
            );
            final authRepository = Provider.of<AuthRepository>(
              context,
              listen: false,
            );
            final shoppingListRepository = Provider.of<ShoppingListRepository>(
              context,
              listen: false,
            );
            final shoppingListService = Provider.of<ShoppingListService>(
              context,
              listen: false,
            );
            final recipeRepository = Provider.of<RecipeRepository>(
              context,
              listen: false,
            );

            return ShoppingListViewModel(
              shoppingListRepository: shoppingListRepository,
              shoppingListService: shoppingListService,
              recipeRepository: recipeRepository,
              weeklyMenuViewModel: weeklyMenuViewModel,
              authRepository: authRepository,
            )..initialize();
          },
        ),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

final AuthRepository _authRepositoryInstance = AuthRepository();
final AuthViewModel _authViewModelInstance = AuthViewModel(
  authRepository: _authRepositoryInstance,
);

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  refreshListenable: _authViewModelInstance,
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
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
              name: 'weekly-menu',
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
              name: 'shopping-list',
              builder: (context, state) => const ShoppingListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cookbook',
              name: 'cookbook',
              builder: (context, state) => const CookbookScreen(),
              routes: [
                GoRoute(
                  path: 'recipe-detail/:id',
                  name: 'recipe-detail',
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
              name: 'settings',
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
      return '/weekly-menu';
    }
    return null;
  },
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: localeProvider.locale,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
