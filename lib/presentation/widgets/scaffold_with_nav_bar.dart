import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklymenu/l10n/app_localizations.dart'; // Import AppLocalizations

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, Key? key})
    : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to return to the
      // initial location of the selected branch when tapping the same item
      // twice. In this example, we go to the initial location when tapping the
      // item for the first time, and we go to the previous location if it's
      // already selected.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.menu_book),
            label: appLocalizations.weeklyMenuTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart),
            label: appLocalizations.shoppingListScreenTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            label: appLocalizations.cookbookTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: appLocalizations.settingsTitle,
          ),
        ],
        onTap: _goBranch,
      ),
    );
  }
}
