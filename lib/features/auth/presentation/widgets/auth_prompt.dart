import 'package:flutter/material.dart';

class AuthPrompt extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AuthPrompt(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                  text: subtitle,
                  style: TextStyle(color: Colors.blue),
                )
              ]),
        ),
      ),
    );
  }
}
