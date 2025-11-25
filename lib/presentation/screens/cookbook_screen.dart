import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/presentation/view_models/cookbook_view_model.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';

class CookbookScreen extends StatelessWidget {
  const CookbookScreen({super.key});

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
      context.pushNamed(
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

  Future<void> _confirmDeleteRecipe(
    BuildContext context,
    CookbookViewModel cookbookViewModel,
    RecipeModel recipe,
  ) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(appLocalizations.deleteRecipeConfirmation(recipe.name)),
          content: Text(appLocalizations.deleteRecipeConfirmation(recipe.name)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(appLocalizations.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              key: const Key('confirm_delete_button'),
              child: Text(appLocalizations.deleteButton),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;

    if (confirm == true) {
      await cookbookViewModel.deleteRecipe(recipe.id!);
      if (cookbookViewModel.errorMessage != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${appLocalizations.errorLoadingRecipes}: ${cookbookViewModel.errorMessage}',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${recipe.name} ${appLocalizations.deletedMessage}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.cookbookTitle),
        actions: [
          IconButton(
            key: const Key('add_recipe_button'),
            icon: const Icon(Icons.add),
            onPressed: () => _showAddRecipeDialog(context),
          ),
        ],
      ),
      body: Consumer<CookbookViewModel>(
        builder: (context, cookbookViewModel, child) {
          if (cookbookViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
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
            return Center(
              child: Text(
                '${appLocalizations.errorLoadingRecipes}: ${cookbookViewModel.errorMessage}',
              ),
            );
          }

          if (cookbookViewModel.recipes.isEmpty) {
            return Center(child: Text(appLocalizations.noRecipesAdded));
          }

          return ListView.builder(
            itemCount: cookbookViewModel.recipes.length,
            itemBuilder: (context, index) {
              final recipe = cookbookViewModel.recipes[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: ListTile(
                  key: Key('recipe_list_item_$index'),
                  title: Text(recipe.name),
                  subtitle: Text(
                    '${appLocalizations.ratingLabel}: ${recipe.rating}/5',
                  ),
                  trailing: IconButton(
                    key: const Key('delete_recipe_item_button'),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDeleteRecipe(
                      context,
                      cookbookViewModel,
                      recipe,
                    ),
                  ),
                  onTap: () {
                    context.pushNamed(
                      'recipe-detail',
                      pathParameters: {'id': recipe.id!},
                      extra: recipe,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
