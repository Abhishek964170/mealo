import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/widgets/meal_search_delegate.dart';
import 'package:meals_app/edamam_services.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // explicit animation
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    // Alternative => Navigator.of(context).push(route);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => MealsScreen(
                  title: category.title,
                  meals: filteredMeals,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    MealSearchDelegate(availableMeals: widget.availableMeals),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        child: GridView(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // left to right
            childAspectRatio: 3 / 2, // size of grid view items
            crossAxisSpacing: 20, // space bet columns horixontally
            mainAxisSpacing: 20, // space bet columns vertically
          ),
          children: [
            // Alternative option
            // avaialableCategories.map((category) => CategoryGridItem(category: category))
            for (final category in availableCategories)
              CategoryGridItem(
                category: category,
                onSelectCategory: () => {_selectCategory(context, category)},
              )
          ],
        ),
        builder: (context, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.3), // push down
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          )),
          child: child,
        ),
      ),
    );
  }
}
