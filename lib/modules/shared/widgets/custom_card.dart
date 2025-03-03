import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Widget child;
  final Color? color;

  const CustomCard({
    required this.title,
    required this.child,
    super.key,
    this.color,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(child: child),
          ],
        ),
      ),
    );
  }
}
