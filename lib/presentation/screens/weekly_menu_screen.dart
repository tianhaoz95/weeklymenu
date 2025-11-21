import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/presentation/view_models/weekly_menu_view_model.dart';

class WeeklyMenuScreen extends StatelessWidget {
  const WeeklyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<WeeklyMenuViewModel>(
                context,
                listen: false,
              ).generateWeeklyMenu();
            },
          ),
        ],
      ),
      body: Consumer<WeeklyMenuViewModel>(
        builder: (context, weeklyMenuViewModel, child) {
          if (weeklyMenuViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (weeklyMenuViewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${weeklyMenuViewModel.errorMessage}'),
                  backgroundColor: Colors.red,
                ),
              );
              weeklyMenuViewModel.clearErrorMessage();
            });
            return Center(
              child: Text('Error: ${weeklyMenuViewModel.errorMessage}'),
            );
          }

          if (weeklyMenuViewModel.weeklyMenu == null ||
              weeklyMenuViewModel.weeklyMenu!.menuItems.isEmpty) {
            return const Center(
              child: Text(
                'No weekly menu generated. Tap the refresh button to generate one!',
              ),
            );
          }

          return ListView.builder(
            itemCount: weeklyMenuViewModel.weeklyMenu!.menuItems.keys.length,
            itemBuilder: (context, index) {
              final day = weeklyMenuViewModel.weeklyMenu!.menuItems.keys
                  .elementAt(index);
              final mealsForDay =
                  weeklyMenuViewModel.weeklyMenu!.menuItems[day]!;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Divider(),
                      ...mealsForDay.map(
                        (item) => ListTile(
                          title: Text(item.recipeName),
                          subtitle: Text(item.mealType),
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
