import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

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
        onPressed: () {
          // Handle menu button press
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
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Handle search button press
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
