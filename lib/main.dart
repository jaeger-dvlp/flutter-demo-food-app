import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app_demo/pages/favorites_page.dart';
import 'package:food_app_demo/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import './providers/theme_provider.dart';

import 'pages/home_page.dart';
import 'pages/detail_page.dart';

import 'models/recipe_model.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final recipe = state.extra as Recipe;
        return DetailPage(recipe: recipe);
      },
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesPage(),
    ),
  ],
);

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Food App Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeProvider),
      routerConfig: _router,
    );
  }
}
