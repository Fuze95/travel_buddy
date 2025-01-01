import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TravelBuddy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to TravelBuddy'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}