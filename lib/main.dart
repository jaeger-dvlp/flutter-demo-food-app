import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app_demo/pages/favorites_page.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_page.dart';
import 'pages/detail_page.dart';

import 'models/recipe_model.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

Future<ThemeMode> loadInitialTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final theme = prefs.getString('themeMode');

  switch (theme) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

Future<void> toggleTheme(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final current = ref.read(themeModeProvider);
  final newMode = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

  ref.read(themeModeProvider.notifier).state = newMode;
  await prefs.setString('themeMode', newMode.name);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final theme = await loadInitialTheme();

  runApp(
    ProviderScope(
      overrides: [themeModeProvider.overrideWith((ref) => theme)],
      child: const MainApp(),
    ),
  );
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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ref.watch(themeModeProvider),
      routerConfig: _router,
    );
  }
}
