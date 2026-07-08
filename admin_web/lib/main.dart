import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const ArtisanBrewApp(),
    ),
  );
}

class ArtisanBrewApp extends StatefulWidget {
  const ArtisanBrewApp({super.key});
  @override
  State<ArtisanBrewApp> createState() => _ArtisanBrewAppState();
}

class _ArtisanBrewAppState extends State<ArtisanBrewApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final router = createRouter(authProvider);

    return MaterialApp.router(
      title: 'Artisan Brew Management',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      routerConfig: router,
    );
  }
}
