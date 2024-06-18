import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/constants.dart';
import 'package:hsma_cpd_project/widgets/button_primary.dart';
import 'package:provider/provider.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> submit() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registering...')),
    );

    if (!mounted) return;

    bool success =
        await Provider.of<AuthProvider>(context, listen: false).register(
      usernameController.text,
      passwordController.text,
    );

    if (success) {
      GoRouter.of(context).go('/profile');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed, please try again.')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                  const SizedBox(height: 80),
                  const Text(
                    'CREATE A NEW ACCOUNT',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  FieldInput(
                    hint: "Username",
                    controller: usernameController,
                    autofocus: true,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  FieldInput(
                    hint: "Password",
                    controller: passwordController,
                    obscureText: true,
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 20),
                  FieldInput(
                    hint: "Confirm Password",
                    controller: confirmPasswordController,
                    obscureText: true,
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(text: 'REGISTER', onPressed: submit),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).go('/login');
                        },
                        child: const Text(
                          'Login',
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
