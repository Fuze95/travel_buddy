import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/theme_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Add other providers here
      ],
      child: const TravelBuddyApp(),
    ),
  );
}

class TravelBuddyApp extends StatelessWidget {
  const TravelBuddyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'TravelBuddy',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}