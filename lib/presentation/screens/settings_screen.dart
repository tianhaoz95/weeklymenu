import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/presentation/view_models/auth_view_model.dart';
import 'package:weeklymenu/presentation/view_models/settings_view_model.dart'; // Import SettingsViewModel
import 'package:weeklymenu/l10n/app_localizations.dart';
import 'package:weeklymenu/presentation/widgets/language_dropdown_widget.dart'; // Import LanguageDropdownWidget
import 'package:weeklymenu/data/models/meal_type_model.dart'; // Import MealTypeModel

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
              appLocalizations
                  .customMealTypes, // Assuming this string will be added to ARB files
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _MealTypeManager(
              settingsViewModel: settingsViewModel,
            ), // New widget for meal type management
            const SizedBox(height: 20),
            Text(
              appLocalizations.selectWeekdaysForMenu,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8.0,
              children: allWeekdays.map((weekday) {
                final bool isSelected =
                    settingsViewModel.currentSettings?.includedWeekdays
                        .contains(weekday) ??
                    false;
                return FilterChip(
                  label: Text(getLocalizedWeekday(weekday)),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    final List<String> currentWeekdays = List.from(
                      settingsViewModel.currentSettings?.includedWeekdays ?? [],
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
            const SizedBox(height: 20),
            Text(
              appLocalizations.languagePreference,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const LanguageDropdownWidget(),
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

class _MealTypeManager extends StatefulWidget {
  final SettingsViewModel settingsViewModel;

  const _MealTypeManager({required this.settingsViewModel});

  @override
  _MealTypeManagerState createState() => _MealTypeManagerState();
}

class _MealTypeManagerState extends State<_MealTypeManager> {
  final TextEditingController _mealTypeNameController = TextEditingController();

  @override
  void dispose() {
    _mealTypeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<List<MealTypeModel>>(
          stream: widget.settingsViewModel.mealTypes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final mealTypes = snapshot.data ?? [];
            return Wrap(
              spacing: 8.0,
              children: mealTypes.map((mealType) {
                return Chip(
                  label: Text(mealType.name),
                  onDeleted: () =>
                      widget.settingsViewModel.deleteMealType(mealType.id),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _mealTypeNameController,
                decoration: InputDecoration(
                  labelText:
                      appLocalizations.newMealTypeHint, // New string for ARB
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    widget.settingsViewModel.addMealType(value);
                    _mealTypeNameController.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                if (_mealTypeNameController.text.isNotEmpty) {
                  widget.settingsViewModel.addMealType(
                    _mealTypeNameController.text,
                  );
                  _mealTypeNameController.clear();
                }
              },
              child: Text(appLocalizations.addButton), // Existing string
            ),
          ],
        ),
      ],
    );
  }
}
