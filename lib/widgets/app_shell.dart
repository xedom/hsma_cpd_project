import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/widgets/avatar.dart';

class BottomNavBarShell extends StatefulWidget {
  final Widget child;

  const BottomNavBarShell({super.key, required this.child});

  @override
  _BottomNavBarShellState createState() => _BottomNavBarShellState();
}

class _BottomNavBarShellState extends State<BottomNavBarShell> {
  static List<Map<String, String>> pages = [
    {'name': 'Home', 'path': '/home'},
    {'name': 'Roulette', 'path': '/roulette'},
    {'name': 'Coin Flip', 'path': '/coin-flip'},
    {'name': 'Crash', 'path': '/crash'},
    {'name': 'Hi-Lo', 'path': '/hi-lo'},
    {'name': 'Profile', 'path': '/profile'},
    {'name': 'Login', 'path': '/login'},
  ];

  int _selectedIndex = 0;
  String _title = pages[0]['name']!;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    GoRouter.of(context).go(pages[index]['path']!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AvatarWithFallback(
              imageUrl: 'https://xed.im/img/pingu.jpg',
              radius: 30,
            )),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // children: [Text('Title', style: TextStyle(color: Colors.white))],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
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
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
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
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
