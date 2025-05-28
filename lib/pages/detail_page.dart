import 'package:flutter/material.dart';

import '../models/recipe_model.dart';

import '../utils/favorite_service.dart';

class DetailPage extends StatefulWidget {
  final Recipe recipe;
  final FavoriteService? favoriteService;

  const DetailPage({super.key, required this.recipe, this.favoriteService});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;
  late final FavoriteService _favoriteService;

  @override
  void initState() {
    super.initState();
    _favoriteService = widget.favoriteService ?? FavoriteService();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final result = await _favoriteService.isFavorite(widget.recipe.idMeal);
    setState(() {
      isFavorite = result;
    });
  }

  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      await _favoriteService.deleteFavorite(widget.recipe.idMeal);
    } else {
      await _favoriteService.addFavorite(widget.recipe.idMeal);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.strMeal),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.recipe.strMealThumb.isEmpty
                  ? const Placeholder(fallbackHeight: 200)
                  : Image.network(widget.recipe.strMealThumb),
            ),
            const SizedBox(height: 16),
            Text(
              "Category : ${widget.recipe.strCategory}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              "Instructions :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.recipe.strInstructions,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
