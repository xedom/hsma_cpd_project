import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
    this.textColor,
    this.disabled = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: color == null
            ? const LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
                ],
              )
            : null,
        color: color?.withOpacity(disabled ? 0.7 : 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                (textColor ?? Colors.white).withOpacity(disabled ? 0.7 : 1.0),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
