import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'circular_nav_item.dart';
import '../screens/home_screen.dart';
import '../screens/favorites_screen.dart';
import '../services/user_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool noFill;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.noFill = false,
  }) : super(key: key);

  void _handleNavigation(BuildContext context, int index) {
    onTap(index);

    // Handle navigation based on index
    switch (index) {
      case 0: // Trip Plan
      // TODO: Navigate to TripPlanScreen when implemented
        break;
      case 1: // Guides
      // TODO: Navigate to GuidesScreen when implemented
        break;
      case 2: // Home
        final userName = context.read<UserProvider>().userName;
        if (userName.isEmpty) {
          // If no user name is set, navigate to login/registration
          // TODO: Navigate to LoginScreen when implemented
          print('No user name found. Should navigate to login.');
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => HomeScreen(userName: userName)
              )
          );
        }
        break;
      case 3: // Maps
      // TODO: Navigate to MapsScreen when implemented
        break;
      case 4: // Favorites
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FavoritesScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> icons = [
      'assets/icons/car.svg',
      'assets/icons/guide-board.svg',
      'assets/icons/home.svg',
      'assets/icons/map-draw.svg',
      'assets/icons/Heart.svg',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          icons.length,
              (index) => CircularNavItem(
            svgPath: icons[index],
            isSelected: currentIndex == index,
            onTap: () => _handleNavigation(context, index),
            noFill: noFill,
          ),
        ),
      ),
    );
  }
}