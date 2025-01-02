import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/search_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isSearchScreen;
  final bool isAddTripScreen;
  final bool isViewPlanScreen;
  final bool isEditTripScreen;

  const CustomAppBar({
    Key? key,
    this.scaffoldKey,
    this.isSearchScreen = false,
    this.isAddTripScreen = false,
    this.isViewPlanScreen = false,
    this.isEditTripScreen = false,
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
        onPressed: () {
          if (scaffoldKey?.currentState?.isDrawerOpen ?? false) {
            Navigator.of(context).pop();
          } else {
            scaffoldKey?.currentState?.openDrawer();
          }
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
            isSearchScreen || isAddTripScreen || isViewPlanScreen || isEditTripScreen
                ? Icons.close
                : Icons.search,
            color: Colors.white,
          ),
          onPressed: isSearchScreen || isAddTripScreen || isViewPlanScreen || isEditTripScreen
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