import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
  });

  final String text;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        onPressed: () {},
        label: Text(text),
        icon: icon,
        style: TextButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              color: Color.fromARGB(255, 34, 31, 248),
            ),
          ),
        ));
  }
}
