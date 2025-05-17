import 'package:flutter/material.dart';

class SuperscriptText extends StatelessWidget {
  const SuperscriptText({
    super.key,
    required this.text,
    required this.superScript,
    required this.color,
    required this.superscriptColor,
  });

  final String text;
  final String superScript;
  final Color color;
  final Color superscriptColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 40,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            superScript,
            style: TextStyle(
              color: superscriptColor,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
