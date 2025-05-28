import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = "favorite_ids";

  Future<void> addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentFavs = prefs.getStringList(_key) ?? [];

    if (!currentFavs.contains(id)) {
      currentFavs.add(id);
      await prefs.setStringList(_key, currentFavs);
    }
  }

  Future<void> deleteFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentFavs = prefs.getStringList(_key) ?? [];

    if (currentFavs.contains(id)) {
      currentFavs.remove(id);
      await prefs.setStringList(_key, currentFavs);
    }
  }

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<bool> isFavorite(String id) async {
    final list = await getFavorites();
    return list.contains(id);
  }
}
