import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/presentation/view_models/shopping_list_view_model.dart';
import 'package:weeklymenu/presentation/view_models/weekly_menu_view_model.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  // Helper to get localized weekday (copied from SettingsScreen)
  String _getLocalizedWeekday(BuildContext context, String weekday) {
    final appLocalizations = AppLocalizations.of(context)!;
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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.shoppingListScreenTitle)),
      body: Consumer<WeeklyMenuViewModel>(
        builder: (context, weeklyMenuViewModel, child) {
          // Update ShoppingListViewModel when WeeklyMenuViewModel changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ShoppingListViewModel>(
              context,
              listen: false,
            ).updateWeeklyMenuViewModel(weeklyMenuViewModel);
          });

          return Consumer<ShoppingListViewModel>(
            builder: (context, shoppingListViewModel, child) {
              if (shoppingListViewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (shoppingListViewModel.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${appLocalizations.error}: ${shoppingListViewModel.errorMessage}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  shoppingListViewModel.clearErrorMessage();
                });
                return Center(
                  child: Text(
                    '${appLocalizations.error}: ${shoppingListViewModel.errorMessage}',
                  ),
                );
              }

              if (shoppingListViewModel.shoppingList.isEmpty) {
                return Center(
                  child: Text(appLocalizations.noItemsInShoppingList),
                );
              }

              return ListView.builder(
                itemCount: shoppingListViewModel.shoppingList.keys.length,
                itemBuilder: (context, index) {
                  final day = shoppingListViewModel.shoppingList.keys.elementAt(
                    index,
                  );
                  final itemsForDay = shoppingListViewModel.shoppingList[day]!;

                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getLocalizedWeekday(context, day).toUpperCase(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Divider(),
                          ...itemsForDay.asMap().entries.map((entry) {
                            final itemIndex = entry.key;
                            final item = entry.value;
                            return CheckboxListTile(
                              title: Text(
                                '${item.quantity} ${item.unit} ${item.name}', // TODO: Localize unit and name formatting
                              ),
                              value: item.isChecked,
                              onChanged: (bool? newValue) {
                                shoppingListViewModel.toggleItemChecked(
                                  day,
                                  itemIndex,
                                  newValue,
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
