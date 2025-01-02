import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/theme_provider.dart';
import 'services/destination_provider.dart';
import 'screens/splash_screen.dart';
import 'services/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DestinationProvider(prefs)),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
          debugShowCheckedModeBanner: false,
          title: 'TravelBuddy',
          theme: ThemeData(
            primaryColor: const Color(0xFF8B9475),
            fontFamily: 'Rubik',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}