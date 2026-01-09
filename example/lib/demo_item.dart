import 'package:flutter/material.dart';

class DialogDemo {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DialogDemo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
