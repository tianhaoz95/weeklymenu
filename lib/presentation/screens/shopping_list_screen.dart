import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';
import 'package:weeklymenu/presentation/view_models/shopping_list_view_model.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

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

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.shoppingListScreenTitle)),
      body: Consumer<ShoppingListViewModel>(
        builder: (context, shoppingListViewModel, child) {
          if (shoppingListViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (shoppingListViewModel.errorMessage != null) {
            return Center(
              child: Text(
                '${appLocalizations.error}: ${shoppingListViewModel.errorMessage}',
              ),
            );
          }

          if (shoppingListViewModel.shoppingList.isEmpty) {
            return Center(child: Text(appLocalizations.noItemsInShoppingList));
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
                        getLocalizedWeekday(day).toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Divider(),
                      ...itemsForDay.map(
                        (item) => CheckboxListTile(
                          title: Text(
                            '${item.quantity} ${item.unit} ${item.name}',
                          ),
                          value: item.isChecked,
                          onChanged: (bool? newValue) {
                            shoppingListViewModel.toggleItemChecked(
                              day,
                              item.id,
                              newValue,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
