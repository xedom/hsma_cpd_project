import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/widgets/avatar.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import 'package:hsma_cpd_project/widgets/social_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AvatarWithFallback(
              imageUrl: 'https://xed.im/img/pingu.jpg',
              radius: 50,
            ),
            const SizedBox(height: 30),
            const Text('Username: Pedro Pè'),
            const SizedBox(height: 10),
            FieldInput(
                label: 'Name',
                hint: 'TODO: add current user name',
                controller: TextEditingController()),
            const SizedBox(height: 10),
            FieldInput(
                label: 'New Password',
                hint: 'New Password',
                controller: TextEditingController()),
            const SizedBox(height: 10),
            FieldInput(
                label: 'Confirm Password',
                hint: 'Confirm Password',
                controller: TextEditingController()),
            const SizedBox(height: 30),
            SocialButton(
              text: "Logout",
              onPressed: () => GoRouter.of(context).go('/logout'),
            ),
          ],
        ),
      ),
    );
  }
}
