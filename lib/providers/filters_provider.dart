import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactosFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactosFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, isActive) {
    // state[Filter] = isActive  is not allowed : mutating state
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider(
  (ref) {
    final meals = ref.watch(mealsProvider);
    final selectedFilter = ref.watch(filtersProvider);
    return meals.where(
      (meal) {
        if (selectedFilter[Filter.glutenFree]! && !meal.isGlutenFree) {
          return false;
        }
        if (selectedFilter[Filter.lactosFree]! && !meal.isLactoseFree) {
          return false;
        }
        if (selectedFilter[Filter.vegan]! && !meal.isVegan) {
          return false;
        }
        if (selectedFilter[Filter.vegetarian]! && !meal.isVegetarian) {
          return false;
        }
        return true;
      },
    ).toList();
  },
);
