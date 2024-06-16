import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/constants.dart';
import 'package:hsma_cpd_project/widgets/button_primary.dart';
import 'package:hsma_cpd_project/widgets/button_secondary.dart';
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
  bool rememberMe = false;

  void submit() {
    Provider.of<AuthProvider>(context, listen: false).login(
      usernameController.text,
      passwordController.text,
    );

    if (usernameController.text == "pedro" &&
        passwordController.text == "1234") {
      GoRouter.of(context).go('/home');
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                const Text(
                  'LOGIN TO YOUR ACCOUNT',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter your login information',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),
                FieldInput(
                  hint: "cliveross@gmail.com",
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                          activeColor: AppColors.primary,
                        ),
                        const Text('Remember me', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'LOGIN',
                  onPressed: submit,
                ),
                const SizedBox(height: 20),
                const Text("Or", style: TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(height: 20),
                SecondaryButton(
                      text: 'GOOGLE',
                      image: 'assets/google_logo.png',
                      onPressed: () {},
                    ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () {},
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
    );
  }
}
