import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TravelBuddy',
      theme: ThemeData(
        primaryColor: const Color(0xFF8B9475),
        primarySwatch: MaterialColor(0xFF8B9475, {
          50: Color(0xFFF4F5F2),
          100: Color(0xFFE3E6DE),
          200: Color(0xFFD1D5C8),
          300: Color(0xFFBEC4B2),
          400: Color(0xFFA5AE96),
          500: Color(0xFF8B9475),
          600: Color(0xFF7D866A),
          700: Color(0xFF6A725A),
          800: Color(0xFF575E4A),
          900: Color(0xFF434839),
        }),
        fontFamily: 'Rubik',
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8B9475)),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF8B9475),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}