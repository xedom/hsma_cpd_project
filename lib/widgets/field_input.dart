import 'package:flutter/material.dart';

class FieldInput extends StatelessWidget {
  const FieldInput({
    super.key,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.autofocus = false,
  });

  final String label;
  final String hint;
  final bool obscureText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      child: TextField(
        controller: TextEditingController(),
        onChanged: (String value) {
          if (value.isNotEmpty) {
          } else {}
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: hint,
        ),
        obscureText: obscureText,
        autofocus: autofocus,
      ),
    );
  }
}
