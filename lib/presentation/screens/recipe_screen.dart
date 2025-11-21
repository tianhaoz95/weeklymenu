import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/presentation/view_models/cookbook_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  // State for recipe properties
  List<String> _selectedCategories = [];
  List<String> _selectedCuisines = [];
  double _selectedRating = 0.0;

  // Available options
  final List<String> _allCategories = [
    'breakfast',
    'lunch',
    'dinner',
    'snack',
    'appetizer',
    'main_course',
    'dessert',
  ];
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
    _ingredientsController.text = _currentRecipe!.ingredients.join(', ');
    _instructionsController.text = _currentRecipe!.instructions.join('\n');
    _selectedCategories = List.from(_currentRecipe!.categories);
    _selectedCuisines = List.from(_currentRecipe!.cuisines);
    _selectedRating = _currentRecipe!.rating;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final cookbookViewModel = Provider.of<CookbookViewModel>(
        context,
        listen: false,
      );

      if (_userId == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not logged in.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newRecipe = RecipeModel(
        id: _currentRecipe!.id,
        name: _nameController.text,
        ingredients: _ingredientsController.text
            .split(',')
            .map((e) => e.trim())
            .toList(),
        instructions: _instructionsController.text
            .split('\n')
            .map((e) => e.trim())
            .toList(),
        categories: _selectedCategories,
        cuisines: _selectedCuisines,
        rating: _selectedRating,
        userId: _userId!,
      );

      if (widget.recipeId == null) {
        // Add new recipe
        await cookbookViewModel.addRecipe(newRecipe);
      } else {
        // Update existing recipe
        await cookbookViewModel.updateRecipe(newRecipe);
      }

      if (cookbookViewModel.errorMessage != null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${cookbookViewModel.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.recipeId == null ? 'Recipe added!' : 'Recipe updated!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        if (!context.mounted) return;
        context.pop(); // Go back to CookbookScreen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipeId == null ? 'New Recipe' : 'Edit Recipe'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveRecipe),
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
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Recipe Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipe name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients (comma-separated)',
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions (each on a new line)',
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              const Text('Cuisines:'),
              Wrap(
                spacing: 8.0,
                children: _allCuisines.map((cuisine) {
                  return FilterChip(
                    label: Text(cuisine),
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
              const Text('Categories:'),
              Wrap(
                spacing: 8.0,
                children: _allCategories.map((category) {
                  return FilterChip(
                    label: Text(category),
                    selected: _selectedCategories.contains(category),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Star Rating:'),
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
