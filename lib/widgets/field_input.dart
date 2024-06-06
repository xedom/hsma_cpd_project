import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FieldInput extends StatelessWidget {
  FieldInput({
    super.key,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.autofocus = false,
    required this.controller,
  });

  final String label;
  final String hint;
  final bool obscureText;
  final bool autofocus;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 360,
      ),
      child: TextField(
        controller: controller,
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
