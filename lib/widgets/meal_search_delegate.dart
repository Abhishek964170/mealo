  import 'package:flutter/material.dart';
  import 'package:meals_app/models/meal.dart';
  import 'package:meals_app/models/recipe.dart';
  import 'package:meals_app/screens/meals.dart';
  import 'package:meals_app/edamam_services.dart';

  class MealSearchDelegate extends SearchDelegate {
    final List<Meal> availableMeals;
    final EdamamService _edamamService = EdamamService();

    MealSearchDelegate({required this.availableMeals});

    @override
    ThemeData appBarTheme(BuildContext context) {
      final ThemeData theme = Theme.of(context);
      return theme.copyWith(
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.white70,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: theme.primaryColor, // Customize the app bar color
          iconTheme:
              IconThemeData(color: Colors.white), // Customize the icon color
        ),
      );
    }

    @override
    List<Widget>? buildActions(BuildContext context) {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ];
    }

    @override
    Widget? buildLeading(BuildContext context) {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );
    }

    @override
    Widget buildResults(BuildContext context) {
      return FutureBuilder(
        future: _searchMeals(query),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Display error
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No results found.'));
          } else {
            final searchResults = snapshot.data!;
            return ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                if (result is Meal) {
                  return ListTile(
                    title: Text(result.title),
                    leading: Image.network(
                      result.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => MealsScreen(
                            title: result.title,
                            meals: [result],
                          ),
                        ),
                      );
                    },
                  );
                } else if (result is Recipe) {
                  return ListTile(
                    title: Text(result.label),
                    leading: Image.network(
                      result.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => RecipeDetailScreen(recipe: result),
                        ),
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              },
            );
          }
        },
      );
    }

    Future<List<dynamic>> _searchMeals(String query) async {
      final localMeals = availableMeals.where((meal) {
        return meal.title.toLowerCase().contains(query.toLowerCase());
      }).toList();

      print('Local meals: ${localMeals.length}');

      final edamamMeals = await _edamamService.fetchRecipes(query);
      return [...localMeals, ...edamamMeals];
    }

    @override
    Widget buildSuggestions(BuildContext context) {
      return Container();
    }
  }

  class RecipeDetailScreen extends StatelessWidget {
    final Recipe recipe;

    RecipeDetailScreen({required this.recipe});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(recipe.label),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                recipe.image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                recipe.label,
                style: TextStyle(color:Colors.white,fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Source: ${recipe.source}',
                style: TextStyle(color:Colors.white,fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Total Time: ${recipe.totalTime} minutes',
                style: TextStyle(color:Colors.white,fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Ingredients:',
                style: TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...recipe.ingredientLines
                  .map((ingredient) => Text(
                '- $ingredient',
                style: TextStyle(color: Colors.white), // Set text color to white
              ))
                  .toList(),
            ],
          ),
        ),
      );
    }
  }
