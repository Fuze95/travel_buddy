import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'circular_nav_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {'icon': 'assets/icons/car.svg', 'label': 'Trip Plan'},
      {'icon': 'assets/icons/guide-board.svg', 'label': 'Guides'},
      {'icon': 'assets/icons/home.svg', 'label': 'Home'},
      {'icon': 'assets/icons/map-draw.svg', 'label': 'Maps'},
      {'icon': 'assets/icons/Heart.svg', 'label': 'Favorites'},
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
          items.length,
              (index) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularNavItem(
                svgPath: items[index]['icon']!,
                isSelected: currentIndex == index,
                onTap: () => onTap(index),
              ),
              const SizedBox(height: 4),
              Text(
                items[index]['label']!,
                style: TextStyle(
                  fontSize: 12,
                  color: currentIndex == index
                      ? const Color(0xFF8B9475)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}