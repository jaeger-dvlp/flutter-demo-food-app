import 'package:dio/dio.dart';

import '../models/recipe_model.dart';

class ApiService {
  final Dio _dio = Dio();

  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1/";

  Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final response = await _dio.get('$baseUrl/search.php?s=$query');

      if (response.data['meals'] == null) return [];

      final List<dynamic> data = response.data["meals"];

      return data.map((e) => Recipe.fromJson(e)).toList();
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
