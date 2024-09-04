import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    // must always create/reassign list
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      // remove the one which isnt equal to the chosen meal and remove the one which is equal
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      // existing meals + new meal
      state = [...state, meal];
      return true;
    }
  }
}

final favoritesMealProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
