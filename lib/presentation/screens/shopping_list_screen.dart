import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';
import 'package:weeklymenu/presentation/view_models/shopping_list_view_model.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  // Locally defined colors for this screen
  static const Color primaryColor = Color(0xFFA3B18A);
  static const Color backgroundColorLight = Color(0xFFF4F3EE);
  static const Color backgroundColorDark = Color(0xFF1f222a);
  static const Color textPrimaryLight = Color(0xFF3D405B);
  static const Color textPrimaryDark = Color(0xFFEAE8E1);
  static const Color textSecondaryLight = Color(0xFF6b6e84);
  static const Color textSecondaryDark = Color(0xFFa0a3b8);
  static const Color accentColor = Color(0xFFF2CC8F);
  static const Color borderColorLight = Color(0xFFe4e2db);
  static const Color borderColorDark = Color(0xFF4a4d5a);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    // Determine if dark mode is active
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Use appropriate colors based on theme
    final Color currentBackgroundColor = isDarkMode
        ? backgroundColorDark
        : backgroundColorLight;
    final Color currentTextPrimaryColor = isDarkMode
        ? textPrimaryDark
        : textPrimaryLight;
    final Color currentTextSecondaryColor = isDarkMode
        ? textSecondaryDark
        : textSecondaryLight;
    final Color currentBorderColor = isDarkMode
        ? borderColorDark
        : borderColorLight;

    return Scaffold(
      backgroundColor: currentBackgroundColor,
      body: Column(
        children: [
          // Custom App Bar
          Container(
            color: currentBackgroundColor,
            padding: const EdgeInsets.only(top: 48.0, bottom: 8.0),
            child: Center(
              child: Text(
                appLocalizations.shoppingListScreenTitle,
                style: textTheme.titleLarge?.copyWith(
                  color: currentTextPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Progress Indicator Section
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Consumer<ShoppingListViewModel>(
              builder: (context, shoppingListViewModel, child) {
                if (shoppingListViewModel.isLoading) {
                  return const SizedBox.shrink(); // Hide progress during loading
                }

                if (shoppingListViewModel.shoppingList.isEmpty) {
                  return const SizedBox.shrink(); // Hide if list is empty
                }

                int totalCheckedItems = 0;
                int totalItems = 0;
                shoppingListViewModel.shoppingList.forEach((day, items) {
                  totalCheckedItems += items
                      .where((item) => item.isChecked)
                      .length;
                  totalItems += items.length;
                });

                final double progress = totalItems == 0
                    ? 0
                    : totalCheckedItems / totalItems;

                return Column(
                  children: [
                    Text(
                      '$totalCheckedItems/$totalItems ${appLocalizations.itemsCompleted}',
                      style: textTheme.bodySmall?.copyWith(
                        color: currentTextSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        999.0,
                      ), // full rounded
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: currentBorderColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          primaryColor,
                        ),
                        minHeight: 10.0,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Shopping List Items
          Expanded(
            child: Consumer<ShoppingListViewModel>(
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: shoppingListViewModel.shoppingList.keys.length,
                  itemBuilder: (context, index) {
                    final day = shoppingListViewModel.shoppingList.keys
                        .elementAt(index);
                    final itemsForDay =
                        shoppingListViewModel.shoppingList[day]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            day, // Display day if grouping is by day
                            style: textTheme.titleMedium?.copyWith(
                              color: currentTextPrimaryColor,
                            ),
                          ),
                        ),
                        ...itemsForDay.map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24.0, // Checkbox size
                                  height: 24.0,
                                  child: Checkbox(
                                    value: item.isChecked,
                                    onChanged: (bool? newValue) {
                                      shoppingListViewModel.toggleItemChecked(
                                        day,
                                        item.id,
                                        newValue,
                                      );
                                    },
                                    activeColor: primaryColor,
                                    checkColor: Colors.white,
                                    side: BorderSide(
                                      color: primaryColor,
                                      width: 2.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: currentBorderColor,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.name,
                                                style: textTheme.bodyMedium?.copyWith(
                                                  color: item.isChecked
                                                      ? currentTextSecondaryColor
                                                      : currentTextPrimaryColor,
                                                  decoration: item.isChecked
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : TextDecoration.none,
                                                ),
                                              ),
                                              Text(
                                                '${item.quantity} ${item.unit}',
                                                style: textTheme.bodySmall?.copyWith(
                                                  color: item.isChecked
                                                      ? currentTextSecondaryColor
                                                      : currentTextSecondaryColor,
                                                  decoration: item.isChecked
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : TextDecoration.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (item.recipeName != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: accentColor.withAlpha(
                                                (255 * 0.3).round(),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(999.0),
                                            ),
                                            child: Text(
                                              item.recipeName!,
                                              style: textTheme.labelSmall?.copyWith(
                                                color: item.isChecked
                                                    ? currentTextSecondaryColor
                                                          .withAlpha(
                                                            (255 * 0.7).round(),
                                                          )
                                                    : textPrimaryLight, // Assuming a darker accent text
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding new item to shopping list
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 28),
      ),
    );
  }
}
