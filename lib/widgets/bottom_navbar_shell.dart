import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBarShell extends StatefulWidget {
  final Widget child;

  const BottomNavBarShell({Key? key, required this.child}) : super(key: key);

  @override
  _BottomNavBarShellState createState() => _BottomNavBarShellState();
}

class _BottomNavBarShellState extends State<BottomNavBarShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('#/roulette');
        break;
      case 2:
        GoRouter.of(context).go('#/coin-flip');
        break;
      case 3:
        GoRouter.of(context).go('#/crash');
        break;
      case 4:
        GoRouter.of(context).go('#/hi-lo');
        break;
      case 5:
        GoRouter.of(context).go('/profile');
        break;
      case 6:
        GoRouter.of(context).go('/login');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.poker_chip),
            icon: Icon(Icons.games),
            label: 'Roulette',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Coin Flip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: 'Crash',
          ),
          BottomNavigationBarItem(
            // icon: Icon(Icons.playing_cards),
            icon: Icon(Icons.card_membership),
            label: 'Hi-Lo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
