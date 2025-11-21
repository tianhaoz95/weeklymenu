import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/presentation/view_models/cookbook_view_model.dart';

class CookbookScreen extends StatelessWidget {
  const CookbookScreen({super.key});

  Future<void> _showAddRecipeDialog(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add New Recipe'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Recipe Name'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Add'),
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
        const SnackBar(
          content: Text('Recipe name cannot be empty.'),
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
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: Text('Are you sure you want to delete "${recipe.name}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
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
              content: Text('Error: ${cookbookViewModel.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${recipe.name}" deleted.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookbook'),
        actions: [
          IconButton(
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
                  content: Text('Error: ${cookbookViewModel.errorMessage}'),
                  backgroundColor: Colors.red,
                ),
              );
              cookbookViewModel.clearErrorMessage();
            });
            return const Center(child: Text('Error loading recipes.'));
          }

          if (cookbookViewModel.recipes.isEmpty) {
            return const Center(
              child: Text(
                'No recipes added yet. Tap + to add your first recipe!',
              ),
            );
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
                  title: Text(recipe.name),
                  subtitle: Text('Rating: ${recipe.rating}/5'),
                  trailing: IconButton(
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
