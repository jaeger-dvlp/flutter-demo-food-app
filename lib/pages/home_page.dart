import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app_demo/pages/detail_page.dart';
import 'package:go_router/go_router.dart';

import '../models/recipe_model.dart';
import '../utils/api_service.dart';

final recipeListProvider = StateProvider<List<Recipe>>((ref) => []);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> _search() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) return;

    final api = ApiService();
    final results = await api.searchRecipes(query);
    ref.read(recipeListProvider.notifier).state = results;
  }

  @override
  Widget build(BuildContext context) {
    final recipeList = ref.watch(recipeListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Yemek Tarifleri Demo"),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              context.push('/favorites');
            },
            child: const Text('Favorites'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Yemek ara...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _search, child: const Text('Ara')),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: recipeList.isEmpty
                  ? const Center(child: const Text('Yemek araması yapın.'))
                  : ListView.builder(
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        final recipe = recipeList[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          child: ListTile(
                            leading: Image.network(
                              recipe.strMealThumb,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                            title: Text(recipe.strMeal),
                            subtitle: Text(recipe.strCategory),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPage(recipe: recipe),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
