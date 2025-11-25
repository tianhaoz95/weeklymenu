import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/presentation/view_models/weekly_menu_view_model.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class WeeklyMenuScreen extends StatefulWidget {
  const WeeklyMenuScreen({super.key});

  @override
  State<WeeklyMenuScreen> createState() => _WeeklyMenuScreenState();
}

class _WeeklyMenuScreenState extends State<WeeklyMenuScreen> {
  // Locally defined colors for this screen
  static const Color primaryColor = Color(0xFF618961);
  static const Color backgroundColorLight = Color(0xFFf6f8f6);
  static const Color backgroundColorDark = Color(0xFF102210);
  static const Color textColorLight = Color(0xFF1F2421);
  static const Color textColorDark = Color(0xFFf6f8f6);
  static const Color cardColorLight = Colors.white;
  static const Color cardColorDark = Color(0xFF1f221e); // Approximation of zinc-900/50 for dark mode

  // Helper to format the date range
  String _formatDateRange(DateTime startDate) {
    final endDate = startDate.add(const Duration(days: 6)); // Assuming a 7-day week starting from startDate
    final DateFormat formatter = DateFormat('MMMM dd');
    return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color currentBackgroundColor = isDarkMode ? backgroundColorDark : backgroundColorLight;
    final Color currentTextColor = isDarkMode ? textColorDark : textColorLight;
    final Color currentCardColor = isDarkMode ? cardColorDark : cardColorLight;

    return Scaffold(
      key: const Key('weekly_menu_screen'),
      backgroundColor: currentBackgroundColor,
      body: Consumer<WeeklyMenuViewModel>(
        builder: (context, weeklyMenuViewModel, child) {
          if (weeklyMenuViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (weeklyMenuViewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${appLocalizations.errorGeneratingMenu}: ${weeklyMenuViewModel.errorMessage}',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              weeklyMenuViewModel.clearErrorMessage();
            });
            return Center(
              child: Text(
                '${appLocalizations.errorGeneratingMenu}: ${weeklyMenuViewModel.errorMessage}',
              ),
            );
          }

          if (weeklyMenuViewModel.weeklyMenu == null || weeklyMenuViewModel.weeklyMenu!.menuItems.isEmpty) {
            return Center(child: Text(appLocalizations.noWeeklyMenuGenerated));
          }

          // Assuming the weekly menu starts from the first day in the menuItems map
          final DateTime startDate = weeklyMenuViewModel.weeklyMenu!.menuItems.keys.first.toDateTime();


          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                expandedHeight: 80.0, // Height for the custom header content
                backgroundColor: currentBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: const EdgeInsets.only(top: 48.0, bottom: 8.0, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: currentTextColor),
                          onPressed: () {
                            // TODO: Implement navigation back or to previous week
                          },
                        ),
                        Expanded(
                          child: Text(
                            _formatDateRange(startDate),
                            style: textTheme.titleLarge?.copyWith(
                              color: currentTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center, // Center the text within the expanded space
                          ),
                        ),
                        const SizedBox(width: 48), // Placeholder for symmetry
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final day = weeklyMenuViewModel.weeklyMenu!.menuItems.keys.elementAt(index);
                    final mealsForDay = weeklyMenuViewModel.weeklyMenu!.menuItems[day]!;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              day.toUpperCase(), // e.g., MONDAY
                              style: textTheme.headlineSmall?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...mealsForDay.map(
                            (item) => _buildMealCard(
                              context,
                              item.recipeName,
                              item.mealType,
                              item.recipeImageUrl,
                              isDarkMode,
                              currentCardColor,
                              currentTextColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: weeklyMenuViewModel.weeklyMenu!.menuItems.keys.length,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('generate_menu_button'),
        onPressed: () {
          Provider.of<WeeklyMenuViewModel>(
            context,
            listen: false,
          ).generateWeeklyMenu();
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.refresh, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    String recipeName,
    String mealType,
    String? imageUrl,
    bool isDarkMode,
    Color currentCardColor,
    Color currentTextColor,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation to recipe detail
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: currentCardColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.05).round()),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeName,
                    style: textTheme.bodyLarge?.copyWith(
                      color: currentTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    mealType,
                    style: textTheme.bodySmall?.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    children: [
                      imageUrl != null && imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.broken_image)),
                            )
                          : const Center(child: Icon(Icons.image, size: 40)),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha((255 * 0.4).round()),
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          child: const Icon(Icons.more_vert, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  DateTime toDateTime() {
    // Assuming day string is in a format like 'MONDAY', 'TUESDAY', etc.
    // This is a placeholder. You might need a more robust way to convert
    // the day string to a DateTime object, potentially using a fixed date
    // for the week and then finding the corresponding day.
    // For now, let's return a dummy date.
    return DateTime.now(); // Placeholder
  }
}
