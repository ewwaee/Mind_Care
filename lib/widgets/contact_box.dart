import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String title;

  const CategoryBox({
    super.key,
    required this.title,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 45,
      decoration: BoxDecoration(
        color: color?.withAlpha(30),
        borderRadius: BorderRadius.circular(30)
      ),
      child: Icon(icon, color: color, size: 25,),
    );
  }
}