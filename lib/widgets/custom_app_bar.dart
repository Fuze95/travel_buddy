import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../screens/search_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final bool isSearchScreen;

  const CustomAppBar({
    Key? key,
    this.onMenuPressed,
    this.isSearchScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF8B9475),
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/drawer.svg',
          color: Colors.white,
        ),
        onPressed: onMenuPressed ?? () {
          Scaffold.of(context).openDrawer();
        },
      ),
      centerTitle: true,
      title: const Text(
        'TravelBuddy',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Rozha One',
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isSearchScreen ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: isSearchScreen
              ? () => Navigator.pop(context)
              : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}