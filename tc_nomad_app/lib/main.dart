import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services here (Firebase, Hive, etc.)
  // await Firebase.initializeApp();
  // await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: TCNomadApp(),
    ),
  );
}

class TCNomadApp extends StatelessWidget {
  const TCNomadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TC Nomad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
