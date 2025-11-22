import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';
import 'package:weeklymenu/presentation/view_models/shopping_list_view_model.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.shoppingListScreenTitle),
      ),
      body: Consumer<ShoppingListViewModel>(
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
              final day = shoppingListViewModel.shoppingList.keys.elementAt(index);
              final itemsForDay = shoppingListViewModel.shoppingList[day]!;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Divider(),
                      ...itemsForDay.map(
                        (item) => CheckboxListTile(
                          title: Text('${item.name} (${item.quantity} ${item.unit})'),
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
      bottomNavigationBar: Consumer<ShoppingListViewModel>(
        builder: (context, shoppingListViewModel, child) {
          if (shoppingListViewModel.shoppingList.isEmpty) {
            return const SizedBox.shrink(); // Hide if list is empty
          }

          int totalCheckedItems = 0;
          int totalItems = 0;
          shoppingListViewModel.shoppingList.forEach((day, items) {
            totalCheckedItems += items.where((item) => item.isChecked).length;
            totalItems += items.length;
          });

          return BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${appLocalizations.totalItems} $totalCheckedItems/$totalItems',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
