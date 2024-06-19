import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/constants.dart';
import 'package:hsma_cpd_project/widgets/button_primary.dart';
import 'package:provider/provider.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> submit() async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logging in...')),
    );

    bool success =
        await Provider.of<AuthProvider>(context, listen: false).login(
      usernameController.text,
      passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      GoRouter.of(context).go('/profile');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed, please try again.')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'LOGIN TO YOUR ACCOUNT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FieldInput(
                    hint: "Username",
                    controller: usernameController,
                    autofocus: true,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  FieldInput(
                    hint: "Password",
                    controller: passwordController,
                    obscureText: true,
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(text: 'LOGIN', onPressed: submit),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).go('/register');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
