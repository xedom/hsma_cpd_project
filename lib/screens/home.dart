import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage('https://xed.im/img/pingu.jpg'),
            // backgroundColor: Colors.white60,
            // backgroundImage: NetworkImage('https://xed.im/random/pingu.gif'),
          ),
        ),
        // title: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Title')],),
        actions: [
          GestureDetector(
            onTap: () => GoRouter.of(context).go('/coins'),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Row(
                children: [
                  Text('100', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 5),
                  Icon(Icons.paid, color: Colors.white),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => GoRouter.of(context).go('/logout'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Home Page'),
            TextButton(
                onPressed: () => GoRouter.of(context).go('/profile'),
                child: const Text('Profile')),
            TextButton(
                onPressed: () => GoRouter.of(context).go('/login'),
                child: const Text('Login')),
            TextButton(
                onPressed: () => GoRouter.of(context).go('/logout'),
                child: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}
