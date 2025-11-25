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
import 'package:weeklymenu/presentation/theme/app_theme.dart'; // Import app_theme
