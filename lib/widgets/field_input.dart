import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/constants.dart';

class FieldInput extends StatelessWidget {
  const FieldInput({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.autofocus = false,
    this.icon,
    this.keyboardType,
  });

  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final bool autofocus;
  final IconData? icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 360,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            autofocus: autofocus,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
