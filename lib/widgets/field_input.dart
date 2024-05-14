import 'package:flutter/material.dart';

class FieldInput extends StatelessWidget {
  const FieldInput({
    super.key,
    required this.label,
    required this.hint,
    required this.obscureText,
  });

  final String label;
  final String hint;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          hintText: hint,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
