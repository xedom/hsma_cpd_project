
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Home Page'),

            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/profile');
            }, child: Text('Profile')),
            
            TextButton(onPressed: () {
              Navigator.pushNamed(context, '/logout');
            }, child: Text('Logout')),
            
          ],
        ),
      ),
    );
  }
}