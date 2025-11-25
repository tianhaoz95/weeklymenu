import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/presentation/view_models/cookbook_view_model.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen> {
  // Locally defined colors for this screen
  static const Color primaryColor = Color(0xFF84A98C);
  static const Color backgroundColorLight = Color(0xFFF4F1DE);
  static const Color backgroundColorDark = Color(0xFF1F2421);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF2C332E);
  static const Color textLight = Color(0xFF3D405B);
  static const Color textDark = Color(0xFFEAE6D5);
  static const Color textSecondaryLight = Color(0xFF84A98C);
  static const Color textSecondaryDark = Color(0xFFB5D1B8);
  static const Color chipLight = Color(0xFFE9E9E0);
  static const Color chipDark = Color(0xFF3D405B);
  static const Color starFilledDarkMode = Color(
    0xFFFFD700,
  ); // Gold color for dark mode stars

  String _selectedFilter = 'All'; // State for selected filter chip

  Future<void> _showAddRecipeDialog(BuildContext context) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final TextEditingController nameController = TextEditingController();
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(appLocalizations.addRecipeTitle),
          content: TextField(
            key: const Key('recipe_name_input_field'),
            controller: nameController,
            decoration: InputDecoration(
              labelText: appLocalizations.recipeNameLabel,
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(appLocalizations.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              key: const Key('add_recipe_dialog_add_button'),
              child: Text(appLocalizations.addButton),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;

    if (confirm == true && nameController.text.isNotEmpty) {
      final newRecipe = RecipeModel.newRecipe(name: nameController.text);
      // Pass a dummy ID for new recipes as path parameter, actual object via extra
      context.goNamed(
        'recipe-detail',
        pathParameters: {'id': 'new'},
        extra: newRecipe,
      );
    } else if (confirm == true && nameController.text.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appLocalizations.recipeNameCannotBeEmpty),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color currentBackgroundColor = isDarkMode
        ? backgroundColorDark
        : backgroundColorLight;
    final Color currentSurfaceColor = isDarkMode ? surfaceDark : surfaceLight;
    final Color currentTextColor = isDarkMode ? textDark : textLight;
    final Color currentTextSecondaryColor = isDarkMode
        ? textSecondaryDark
        : textSecondaryLight;
    final Color currentChipColor = isDarkMode ? chipDark : chipLight;

    return Scaffold(
      backgroundColor: currentBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            backgroundColor: currentBackgroundColor.withAlpha(
              (255 * 0.8).round(),
            ),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            toolbarHeight: 120,
            title: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48), // Placeholder for leading
                      Text(
                        appLocalizations.cookbookScreenTitle,
                        style: textTheme.titleLarge?.copyWith(
                          color: currentTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: currentTextColor),
                        onPressed: () {
                          // TODO: Implement search functionality
                        },
                      ),
                    ],
                  ),
                ),
                // Filter Chips
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildFilterChip(
                        context,
                        'All',
                        appLocalizations.all,
                        isDarkMode,
                        currentChipColor,
                        currentTextColor,
                        currentTextSecondaryColor,
                        (filter) => setState(() => _selectedFilter = filter),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        'Breakfast',
                        appLocalizations.breakfast,
                        isDarkMode,
                        currentChipColor,
                        currentTextColor,
                        currentTextSecondaryColor,
                        (filter) => setState(() => _selectedFilter = filter),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        'Lunch',
                        appLocalizations.lunch,
                        isDarkMode,
                        currentChipColor,
                        currentTextColor,
                        currentTextSecondaryColor,
                        (filter) => setState(() => _selectedFilter = filter),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        'Dinner',
                        appLocalizations.dinner,
                        isDarkMode,
                        currentChipColor,
                        currentTextColor,
                        currentTextSecondaryColor,
                        (filter) => setState(() => _selectedFilter = filter),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        'Snack',
                        appLocalizations.snack,
                        isDarkMode,
                        currentChipColor,
                        currentTextColor,
                        currentTextSecondaryColor,
                        (filter) => setState(() => _selectedFilter = filter),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer<CookbookViewModel>(
            builder: (context, cookbookViewModel, child) {
              if (cookbookViewModel.isLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (cookbookViewModel.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${appLocalizations.errorLoadingRecipes}: ${cookbookViewModel.errorMessage}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  cookbookViewModel.clearErrorMessage();
                });
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      '${appLocalizations.errorLoadingRecipes}: ${cookbookViewModel.errorMessage}',
                    ),
                  ),
                );
              }

              if (cookbookViewModel.recipes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text(appLocalizations.noRecipesAdded)),
                );
              }

              final filteredRecipes = _selectedFilter == 'All'
                  ? cookbookViewModel.recipes
                  : cookbookViewModel.recipes.where((recipe) {
                      // TODO: Implement actual filtering based on recipe categories/meal types
                      return recipe.categories.contains(_selectedFilter);
                    }).toList();

              if (filteredRecipes.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text(appLocalizations.noRecipesAdded)),
                );
              }

              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.55,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final recipe = filteredRecipes[index];
                  return _buildRecipeCard(
                    context,
                    recipe,
                    cookbookViewModel,
                    isDarkMode,
                    currentSurfaceColor,
                    currentTextColor,
                    currentTextSecondaryColor,
                  );
                }, childCount: filteredRecipes.length),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecipeDialog(context),
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999.0),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String filterValue,
    String label,
    bool isDarkMode,
    Color currentChipColor,
    Color currentTextColor,
    Color currentTextSecondaryColor,
    ValueChanged<String> onSelected,
  ) {
    final bool isSelected = _selectedFilter == filterValue;
    return GestureDetector(
      onTap: () => onSelected(filterValue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : currentChipColor,
          borderRadius: BorderRadius.circular(999.0),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? (isDarkMode ? textDark : Colors.white)
                : currentTextColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(
    BuildContext context,
    RecipeModel recipe,
    CookbookViewModel cookbookViewModel,
    bool isDarkMode,
    Color currentSurfaceColor,
    Color currentTextColor,
    Color currentTextSecondaryColor,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        context.goNamed(
          'recipe-detail',
          pathParameters: {'id': recipe.id!},
          extra: recipe,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: currentSurfaceColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.05).round()),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
                child: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                    ? Image.network(
                        recipe.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(child: Icon(Icons.broken_image)),
                      )
                    : const Center(child: Icon(Icons.image, size: 50)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: textTheme.bodyLarge?.copyWith(
                      color: currentTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < recipe.rating ? Icons.star : Icons.star_border,
                        color: isDarkMode ? starFilledDarkMode : primaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${recipe.prepTimeMinutes} min, Serves ${recipe.servingSize}',
                    style: textTheme.bodySmall?.copyWith(
                      color: currentTextSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
