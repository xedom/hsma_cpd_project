import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/widgets/avatar.dart';
import 'package:hsma_cpd_project/widgets/button_primary.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AvatarWithFallback(
                  imageUrl: 'https://xed.im/img/pingu.jpg',
                  radius: 50,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Username: Pedro Pè',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                FieldInput(
                  hint: 'TODO: add current user name',
                  controller: TextEditingController(),
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                FieldInput(
                  hint: 'New Password',
                  controller: TextEditingController(),
                  obscureText: true,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 10),
                FieldInput(
                  hint: 'Confirm Password',
                  controller: TextEditingController(),
                  obscureText: true,
                  icon: Icons.lock,
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  text: "Logout",
                  onPressed: () => GoRouter.of(context).go('/logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
