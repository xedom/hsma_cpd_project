import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import 'package:hsma_cpd_project/widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FieldInput(
                label: "Username",
                hint: "ex. pedro",
                controller: usernameController,
                autofocus: true),
            const SizedBox(height: 10),
            FieldInput(
                label: "Password",
                hint: "ex. •••••••••",
                controller: passwordController,
                obscureText: true),
            const SizedBox(height: 10),
            // TextButton(
            //     onPressed: () { Navigator.pushNamed(context, '/home'); },
            //     child: const Text('Login')),
            SocialButton(text: "Login", onPressed: submit),
            const SizedBox(height: 20),
            const Text("or"),
            const SizedBox(height: 20),
            SocialButton(
                text: "Login with Google",
                icon: const Icon(Icons.accessible_forward),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
