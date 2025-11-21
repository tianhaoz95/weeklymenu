import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';
import 'package:weeklymenu/presentation/view_models/settings_view_model.dart'; // Import SettingsViewModel

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmAccountDeletion(
    BuildContext context,
    AuthViewModel authViewModel,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Account Deletion'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
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
            title: const Text('Re-authenticate'),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter your password to confirm',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  password = passwordController.text;
                  Navigator.of(dialogContext).pop(true);
                },
                child: const Text('Confirm'),
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
              content: Text('Password is required to delete account.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final settingsViewModel = Provider.of<SettingsViewModel>(context);

    const List<String> allMealTypes = [
      'breakfast',
      'lunch',
      'dinner',
      'snack'
    ];
    const List<String> allWeekdays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${authViewModel.currentUser?.email ?? 'Guest'}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(
              'Select Meals for Weekly Menu:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8.0,
              children: allMealTypes.map((mealType) {
                return FilterChip(
                  label: Text(mealType),
                  selected: settingsViewModel.settings.selectedMeals.contains(mealType),
                  onSelected: (bool selected) {
                    List<String> updatedMeals = List.from(settingsViewModel.settings.selectedMeals);
                    if (selected) {
                      updatedMeals.add(mealType);
                    } else {
                      updatedMeals.remove(mealType);
                    }
                    settingsViewModel.updateSelectedMeals(updatedMeals);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Weekdays for Weekly Menu:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8.0,
              children: allWeekdays.map((weekday) {
                return FilterChip(
                  label: Text(weekday),
                  selected: settingsViewModel.settings.selectedWeekdays.contains(weekday),
                  onSelected: (bool selected) {
                    List<String> updatedWeekdays = List.from(settingsViewModel.settings.selectedWeekdays);
                    if (selected) {
                      updatedWeekdays.add(weekday);
                    } else {
                      updatedWeekdays.remove(weekday);
                    }
                    settingsViewModel.updateSelectedWeekdays(updatedWeekdays);
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
                    : const Text('Sign Out'),
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
                child: const Text('Delete Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
