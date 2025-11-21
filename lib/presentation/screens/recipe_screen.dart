import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weeklymenu/data/models/recipe_model.dart';
import 'package:weeklymenu/presentation/view_models/cookbook_view_model.dart';

class RecipeScreen extends StatefulWidget {
  final String? recipeId; // Null for new recipe, ID for existing

  const RecipeScreen({super.key, this.recipeId});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  // State for recipe properties
  String _selectedStyle = 'daily';
  List<String> _selectedTypes = [];
  int _selectedRating = 1;

  // Available options
  final List<String> _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];
  final List<String> _recipeStyles = ['daily', 'gourmet', 'quick', 'healthy', 'vegetarian', 'vegan'];

  RecipeModel? _currentRecipe;

  @override
  void initState() {
    super.initState();
    // New recipe, set defaults
    if (widget.recipeId == null) {
      _currentRecipe = RecipeModel.newRecipe(name: '');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch existing recipe if recipeId is provided and not already fetched
    if (widget.recipeId != null && _currentRecipe == null) {
      final cookbookViewModel = Provider.of<CookbookViewModel>(context, listen: false);
      _currentRecipe = cookbookViewModel.recipes.firstWhere(
        (recipe) => recipe.id == widget.recipeId,
        orElse: () => RecipeModel.newRecipe(name: ''), // Fallback
      );
      if (_currentRecipe != null) {
        _nameController.text = _currentRecipe!.name;
        _ingredientsController.text = _currentRecipe!.ingredients.join(', ');
        _selectedStyle = _currentRecipe!.style;
        _selectedTypes = List.from(_currentRecipe!.type);
        _selectedRating = _currentRecipe!.rating;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  void _saveRecipe() async {
    if (_formKey.currentState!.validate()) {
      final cookbookViewModel = Provider.of<CookbookViewModel>(context, listen: false);
      final newRecipe = RecipeModel(
        id: _currentRecipe!.id, // Keep existing ID or '' for new
        name: _nameController.text,
        ingredients: _ingredientsController.text.split(',').map((e) => e.trim()).toList(),
        style: _selectedStyle,
        type: _selectedTypes,
        rating: _selectedRating,
      );

      if (widget.recipeId == null || _currentRecipe!.id.isEmpty) {
        // Add new recipe
        await cookbookViewModel.addRecipe(newRecipe);
        if (!context.mounted) return; // Add this check
      } else {
        // Update existing recipe
        await cookbookViewModel.updateRecipe(newRecipe);
        if (!context.mounted) return; // Add this check
      }

      if (cookbookViewModel.errorMessage != null) {
        if (!context.mounted) return; // Move this check here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${cookbookViewModel.errorMessage}'), backgroundColor: Colors.red),
          );
      } else {
        if (!context.mounted) return; // Move this check here
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.recipeId == null ? 'Recipe added!' : 'Recipe updated!'),
              backgroundColor: Colors.green,
            ),
          );
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
          IconButton(
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
                    labelText: 'Ingredients (comma-separated)'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStyle,
                decoration: const InputDecoration(labelText: 'Style'),
                items: _recipeStyles.map((style) {
                  return DropdownMenuItem(value: style, child: Text(style));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStyle = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Meal Type(s):'),
              Wrap(
                spacing: 8.0,
                children: _mealTypes.map((type) {
                  return FilterChip(
                    label: Text(type),
                    selected: _selectedTypes.contains(type),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedTypes.add(type);
                        } else {
                          _selectedTypes.remove(type);
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
                      index < _selectedRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedRating = index + 1;
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