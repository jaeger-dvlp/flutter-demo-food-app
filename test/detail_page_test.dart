import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:food_app_demo/models/recipe_model.dart';
import 'package:food_app_demo/pages/detail_page.dart';
import 'package:food_app_demo/utils/favorite_service.dart';

class MockFavoriteService extends Mock implements FavoriteService {}

void main() {
  late MockFavoriteService mockFavoriteService;

  setUp(() {
    mockFavoriteService = MockFavoriteService();
  });

  testWidgets("When click to fav button, favorite status must change.", (
    WidgetTester tester,
  ) async {
    final recipe = Recipe(
      idMeal: "52772",
      strMeal: "Test Food",
      strCategory: "Test Category",
      strArea: "Test Area",
      strInstructions: "Its a test.",
      strMealThumb: "",
    );

    when(
      () => mockFavoriteService.isFavorite(any()),
    ).thenAnswer((_) async => false);

    when(() => mockFavoriteService.addFavorite(any())).thenAnswer((_) async {});

    when(
      () => mockFavoriteService.deleteFavorite(any()),
    ).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: DetailPage(recipe: recipe, favoriteService: mockFavoriteService),
      ),
    );

    final starBtn = find.byIcon(Icons.star_border);

    expect(starBtn, findsOneWidget);

    await tester.tap(starBtn);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star), findsOneWidget);
  });
}
