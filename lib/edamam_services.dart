import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meals_app/models/recipe.dart';

class EdamamService {
  final String _appId = 'a77a8b98';
  final String _appKey = '604c0b8ab19c3052eba71c96a278e680';
  final String _baseUrl = 'https://api.edamam.com/search';

  Future<List<Recipe>> fetchRecipes(String query) async {
    final url = '$_baseUrl?q=$query&app_id=$_appId&app_key=$_appKey';
    print('Fetching from URL: $url'); // Debugging the URL

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Recipe> recipes = [];
      for (var item in data['hits']) {
        recipes.add(Recipe.fromJson(item['recipe']));
      }
      print('API meals: ${recipes.length}');
      return recipes;
    } else {
      print(
          'Failed to load recipes: ${response.body}'); // Print the error message
      throw Exception('Failed to load recipes');
    }
  }
}
