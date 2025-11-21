import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';
import 'package:weeklymenu/presentation/view_models/settings_view_model.dart'; // Import SettingsViewModel
import 'package:weeklymenu/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmAccountDeletion(
    BuildContext context,
    AuthViewModel authViewModel,
  ) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(appLocalizations.confirmAccountDeletionTitle),
          content: Text(appLocalizations.confirmAccountDeletionContent),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(appLocalizations.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(appLocalizations.deleteButton),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return; // Add this check

    if (confirm == true) {
      String? password = ''; // Placeholder for password input
      final TextEditingController passwordController = TextEditingController();

      final bool? reauthenticate = await showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(appLocalizations.reauthenticateTitle),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: appLocalizations.passwordHint,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(appLocalizations.cancelButton),
              ),
              TextButton(
                onPressed: () {
                  password = passwordController.text;
                  Navigator.of(dialogContext).pop(true);
                },
                child: Text(appLocalizations.confirmButton),
              ),
            ],
          );
        },
      );

      if (!context.mounted) return; // Add this check

      if (reauthenticate == true && password != null && password!.isNotEmpty) {
        await authViewModel.deleteAccount(password: password!);
        if (authViewModel.errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authViewModel.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else if (reauthenticate == true &&
          (password == null || password!.isEmpty)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(appLocalizations.passwordRequiredToDeleteAccount),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final authViewModel = Provider.of<AuthViewModel>(context);
    final settingsViewModel = Provider.of<SettingsViewModel>(context);

    // Helper to get localized meal type
    String getLocalizedMealType(String mealType) {
      switch (mealType) {
        case 'breakfast':
          return appLocalizations.breakfast;
        case 'lunch':
          return appLocalizations.lunch;
        case 'dinner':
          return appLocalizations.dinner;
        case 'snack':
          return appLocalizations.snack;
        default:
          return mealType;
      }
    }

    // Helper to get localized weekday
    String getLocalizedWeekday(String weekday) {
      switch (weekday) {
        case 'monday':
          return appLocalizations.monday;
        case 'tuesday':
          return appLocalizations.tuesday;
        case 'wednesday':
          return appLocalizations.wednesday;
        case 'thursday':
          return appLocalizations.thursday;
        case 'friday':
          return appLocalizations.friday;
        case 'saturday':
          return appLocalizations.saturday;
        case 'sunday':
          return appLocalizations.sunday;
        default:
          return weekday;
      }
    }

    const List<String> allMealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];
    const List<String> allWeekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.settingsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${appLocalizations.welcomeMessage}, ${authViewModel.currentUser?.email ?? appLocalizations.guest}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              appLocalizations.selectMealsForMenu,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8.0,
              children: allMealTypes.map((mealType) {
                final bool isSelected =
                    settingsViewModel.currentUserModel?.enabledMeals.contains(
                      mealType,
                    ) ??
                    false;
                return FilterChip(
                  label: Text(getLocalizedMealType(mealType)),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    final List<String> currentMeals = List.from(
                      settingsViewModel.currentUserModel?.enabledMeals ?? [],
                    );
                    if (selected) {
                      currentMeals.add(mealType);
                    } else {
                      currentMeals.remove(mealType);
                    }
                    settingsViewModel.updateIncludedMeals(currentMeals);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              appLocalizations.selectWeekdaysForMenu,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8.0,
              children: allWeekdays.map((weekday) {
                final bool isSelected =
                    settingsViewModel.currentUserModel?.enabledDays.contains(
                      weekday,
                    ) ??
                    false;
                return FilterChip(
                  label: Text(getLocalizedWeekday(weekday)),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    final List<String> currentWeekdays = List.from(
                      settingsViewModel.currentUserModel?.enabledDays ?? [],
                    );
                    if (selected) {
                      currentWeekdays.add(weekday);
                    } else {
                      currentWeekdays.remove(weekday);
                    }
                    settingsViewModel.updateIncludedWeekdays(currentWeekdays);
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authViewModel.isLoading
                    ? null
                    : () async {
                        await authViewModel.signOut();
                      },
                child: authViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : Text(appLocalizations.logoutButton),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: authViewModel.isLoading
                    ? null
                    : () => _confirmAccountDeletion(context, authViewModel),
                child: Text(appLocalizations.deleteAccountButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
