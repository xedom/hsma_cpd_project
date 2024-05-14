import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/widgets/field_input.dart';
import 'package:hsma_cpd_project/widgets/social_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void loginWithCredentials() {
    const username = "pedro";
    const password = "123456";

    if (username == "pedro" && password == "123456") {
      print("Login successful");
      Navigator.pushNamed(context, '/home');
    } else {
      print("Login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const FieldInput(
                label: "Username", hint: "ex. Pedro Pè", obscureText: true),
            const SizedBox(height: 10),
            const FieldInput(
                label: "Password", hint: "ex. •••••••••", obscureText: true),
            const SizedBox(height: 10),
            // TextButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, '/home');
            //     },
            //     child: const Text('Login')),
            SocialButton(text: "Login", onPressed: () {}),
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
