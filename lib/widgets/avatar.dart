import 'package:flutter/material.dart';

class AvatarWithFallback extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final IconData fallbackIcon;

  const AvatarWithFallback({
    super.key,
    required this.imageUrl,
    required this.radius,
    this.fallbackIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Icon(
              fallbackIcon,
              size: radius,
              color: Colors.grey,
            );
          },
        ),
      ),
    );
  }
}
