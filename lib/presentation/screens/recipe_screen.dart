import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/presentation/view_models/cookbook_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weeklymenu/l10n/app_localizations.dart';

class RecipeScreen extends StatefulWidget {
  final String? recipeId; // Null for new recipe, ID for existing
  final RecipeModel? recipe;

  const RecipeScreen({super.key, this.recipeId, this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _singleIngredientController =
      TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  // State for recipe properties
  List<String> _selectedCategories = [];
  List<String> _selectedCuisines = [];
  double _selectedRating = 0.0;

  // Available options
  final List<String> _allCuisines = [
    'american',
    'italian',
    'mexican',
    'indian',
    'chinese',
    'japanese',
    'mediterranean',
  ];

  RecipeModel? _currentRecipe;
  String? _userId;

  // Helper to get localized cuisine name
  String _getLocalizedCuisine(
    AppLocalizations appLocalizations,
    String cuisine,
  ) {
    switch (cuisine) {
      case 'american':
        return appLocalizations.american;
      case 'italian':
        return appLocalizations.italian;
      case 'mexican':
        return appLocalizations.mexican;
      case 'indian':
        return appLocalizations.indian;
      case 'chinese':
        return appLocalizations.chinese;
      case 'japanese':
        return appLocalizations.japanese;
      case 'mediterranean':
        return appLocalizations.mediterranean;
      default:
        return cuisine;
    }
  }

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;

    if (widget.recipeId == null && widget.recipe == null) {
      // New recipe
      _currentRecipe = RecipeModel.newRecipe(name: '', userId: _userId);
    } else if (widget.recipe != null) {
      // Existing recipe passed directly (e.g., from CookbookScreen)
      _currentRecipe = widget.recipe;
    } else {
      // Existing recipe, fetch from ViewModel if not already in widget.recipe
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final cookbookViewModel = Provider.of<CookbookViewModel>(
          context,
          listen: false,
        );
        _currentRecipe = cookbookViewModel.recipes.firstWhere(
          (recipe) => recipe.id == widget.recipeId,
          orElse: () => RecipeModel.newRecipe(
            name: '',
            userId: _userId,
          ), // Fallback if not found
        );
        _populateFields();
      });
    }

    if (_currentRecipe != null && _currentRecipe!.name.isNotEmpty) {
      _populateFields();
    }
  }

  void _populateFields() {
    _nameController.text = _currentRecipe!.name;
    _instructionsController.text = _currentRecipe!.instructions.join('\n');
    _selectedCategories = List.from(_currentRecipe!.categories);
    _selectedCuisines = List.from(_currentRecipe!.cuisines);
    _selectedRating = _currentRecipe!.rating;
  }

  void _addIngredient() {
    final newIngredient = _singleIngredientController.text.trim();
    if (newIngredient.isNotEmpty &&
        !_currentRecipe!.ingredients.contains(newIngredient)) {
      setState(() {
        _currentRecipe = _currentRecipe!.copyWith(
          ingredients: List.from(_currentRecipe!.ingredients)
            ..add(newIngredient),
        );
        _singleIngredientController.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _currentRecipe = _currentRecipe!.copyWith(
        ingredients: List.from(_currentRecipe!.ingredients)..remove(ingredient),
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _singleIngredientController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _saveRecipe() async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final cookbookViewModel = Provider.of<CookbookViewModel>(
        context,
        listen: false,
      );

      if (_userId == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(appLocalizations.userNotLoggedInError),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newRecipe = RecipeModel(
        id: _currentRecipe!.id,
        name: _nameController.text,
        ingredients: _currentRecipe!.ingredients,
        instructions: _instructionsController.text
            .split('\n')
            .map((e) => e.trim())
            .toList(),
        categories: _selectedCategories,
        cuisines: _selectedCuisines,
        rating: _selectedRating,
        userId: _userId!,
      );

      if (widget.recipeId == null || widget.recipeId == 'new') {
        // Add new recipe
        await cookbookViewModel.addRecipe(newRecipe);
      } else {
        // Update existing recipe
        await cookbookViewModel.updateRecipe(newRecipe);
      }

      if (cookbookViewModel.errorMessage != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${appLocalizations.errorLoadingRecipes}: ${cookbookViewModel.errorMessage}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.recipeId == null || widget.recipeId == 'new'
                  ? appLocalizations.recipeAddedMessage
                  : appLocalizations.recipeUpdatedMessage,
            ),
            backgroundColor: Colors.green,
          ),
        );
        if (!mounted) return;
        context.pop(); // Go back to CookbookScreen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipeId == null
              ? appLocalizations.addRecipeTitle
              : appLocalizations.editRecipeTitle,
        ),
        actions: [
          IconButton(
            key: const Key('save_recipe_button'),
            icon: const Icon(Icons.save),
            onPressed: _saveRecipe,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                key: const Key('recipe_name_input_field'),
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: appLocalizations.recipeNameLabel,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return appLocalizations
                        .recipeNameLabel; // Using recipeNameLabel for validation message
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // New UI for ingredients
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('single_ingredient_input_field'),
                      controller: _singleIngredientController,
                      decoration: InputDecoration(
                        labelText: appLocalizations.ingredientLabel,
                        hintText: appLocalizations.addIngredientHint,
                      ),
                      onFieldSubmitted: (value) {
                        _addIngredient();
                      },
                    ),
                  ),
                  IconButton(
                    key: const Key('add_ingredient_button'),
                    icon: const Icon(Icons.add),
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              if (_currentRecipe != null &&
                  _currentRecipe!.ingredients.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _currentRecipe!.ingredients.map((ingredient) {
                    return Chip(
                      key: ValueKey(ingredient),
                      label: Text(ingredient),
                      onDeleted: () => _removeIngredient(ingredient),
                      deleteIcon: const Icon(Icons.close),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('instructions_input_field'),
                controller: _instructionsController,
                decoration: InputDecoration(
                  labelText: appLocalizations.instructionsLabel,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              Text(appLocalizations.cuisinesLabel),
              Wrap(
                spacing: 8.0,
                children: _allCuisines.map((cuisine) {
                  return FilterChip(
                    label: Text(
                      _getLocalizedCuisine(appLocalizations, cuisine),
                    ),
                    selected: _selectedCuisines.contains(cuisine),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedCuisines.add(cuisine);
                        } else {
                          _selectedCuisines.remove(cuisine);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Consumer<CookbookViewModel>(
                builder: (context, cookbookViewModel, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(appLocalizations.categoriesLabel),
                      Wrap(
                        spacing: 8.0,
                        children: cookbookViewModel.mealTypes.map((mealType) {
                          final bool isSelected =
                              _selectedCategories.contains(mealType.name);
                          return FilterChip(
                            label: Text(mealType.name),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedCategories.add(mealType.name);
                                } else {
                                  _selectedCategories.remove(mealType.name);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(appLocalizations.starRatingLabel),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedRating.toInt()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = (index + 1).toDouble();
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
