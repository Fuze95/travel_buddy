import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../screens/home_screen.dart';
import '../screens/trip_planning_screen.dart';
import '../screens/travel_guides_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/map_screen.dart';
import '../screens/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomDrawer({
    Key? key,
    this.scaffoldKey,
  }) : super(key: key);

  void _closeDrawer(BuildContext context) {
    if (scaffoldKey?.currentState?.isDrawerOpen ?? false) {
      scaffoldKey?.currentState?.closeDrawer();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 90),
                child: Text(
                  'TravelBuddy',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Rozha One',
                    color: Color(0xFF8B9475),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildDrawerItem(
                    context,
                    'Home',
                        () {
                      _closeDrawer(context);
                      final userName = context.read<UserProvider>().userName;
                      if (userName.isEmpty) {
                        print('No user name found. Should navigate to login.');
                      } else {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(userName: userName)
                            )
                        );
                      }
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    'Trip Planning',
                        () {
                      _closeDrawer(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const TripPlanningScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    'Travel Guides',
                        () {
                      _closeDrawer(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const TravelGuideScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    'Favorite Destinations',
                        () {
                      _closeDrawer(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    'Explore Destinations',
                        () {
                      _closeDrawer(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MapScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    'Settings',
                        () {
                      _closeDrawer(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '© 2025 developed by',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'V. G. S. M. Wijerathna (2421736)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'H.H.B.S. Gunawardena (2431659)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'P.T.D Jayatissa (2430778)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}