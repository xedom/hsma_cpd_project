import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Profile Page'),
            const SizedBox(height: 20),
            const Text('Name: Pedro Pè'),
            const Text(
              'Email: ',
              // style: TextStyle(color: Theme.of(context).colorScheme.primary)
            ),
            const Text(
              'Phone: ',
              // style: TextStyle(color: Theme.of(context).colorScheme.primary)
            ),
            TextButton(
                onPressed: () {
                  GoRouter.of(context).go('/home');
                },
                child: const Text('Home')),
            TextButton(
                onPressed: () {
                  GoRouter.of(context).go('/logout');
                },
                child: const Text('logout')),
          ],
        ),
      ),
    );
  }
}
