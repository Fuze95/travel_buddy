import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularNavItem extends StatelessWidget {
  final String svgPath;
  final bool isSelected;
  final VoidCallback onTap;

  const CircularNavItem({
    Key? key,
    required this.svgPath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? const Color(0xFF8B9475) : Colors.white,
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
