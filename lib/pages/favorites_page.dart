import 'package:flutter/material.dart';
import 'package:food_app_demo/utils/api_service.dart';
import '../models/recipe_model.dart';
import '../pages/detail_page.dart';
import '../utils/favorite_service.dart';

class FavoritesPage extends StatefulWidget {
  final FavoriteService? favoriteService;
  const FavoritesPage({super.key, this.favoriteService});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Recipe> favoriteRecipes = [];
  bool isLoading = true;
  late final FavoriteService _favoriteService;

  @override
  void initState() {
    super.initState();
    _favoriteService = widget.favoriteService ?? FavoriteService();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      isLoading = true;
    });

    final favoriteIds = await _favoriteService.getFavorites();
    List<Recipe> loadedFavorites = [];

    for (final id in favoriteIds) {
      final recipe = await ApiService().getRecipeById(id);
      if (recipe != null) {
        loadedFavorites.add(recipe);
      }
    }

    setState(() {
      favoriteRecipes = loadedFavorites;
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(String id) async {
    await _favoriteService.deleteFavorite(id);
    await _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Meals')),
      body: favoriteRecipes.isEmpty
          ? const Center(child: Text('Please add favorite meals.'))
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(recipe.strMealThumb),
                  ),
                  title: Text(recipe.strMeal),
                  subtitle: Text(recipe.strCategory),
                  trailing: IconButton(
                    onPressed: () {
                      _removeFavorite(recipe.idMeal);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(recipe: recipe),
                      ),
                    ).then((_) => {_loadFavorites()});
                  },
                );
              },
            ),
    );
  }
}
