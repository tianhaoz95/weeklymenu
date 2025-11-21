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
          title: Text(appLocalizations.deleteAccountButton), // Re-using delete account button string for title
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.', // TODO: Localize this
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'), // TODO: Localize
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'), // TODO: Localize
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
            title: const Text('Re-authenticate'), // TODO: Localize
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
                child: const Text('Cancel'), // TODO: Localize
              ),
              TextButton(
                onPressed: () {
                  password = passwordController.text;
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text('Confirm'), // TODO: Localize
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
            const SnackBar(
              content: Text('Password is required to delete account.'), // TODO: Localize
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
      appBar: AppBar(title: Text(appLocalizations.settingsScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${appLocalizations.welcomeMessage}, ${authViewModel.currentUser?.email ?? 'Guest'}!', // TODO: Localize 'Guest'
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
                  label: Text(mealType), // TODO: Localize mealType values
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
                  label: Text(weekday), // TODO: Localize weekday values
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
