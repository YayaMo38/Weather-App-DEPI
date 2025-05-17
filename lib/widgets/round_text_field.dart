import 'package:flutter/material.dart';

class RoundTextField extends StatelessWidget {
  const RoundTextField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextField(
        style: TextStyle(
          color: theme.colorScheme.onBackground,
        ),
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onBackground.withOpacity(0.6),
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(
            color: theme.colorScheme.onBackground.withOpacity(0.5),
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        ),
      ),
    );
  }
}
