import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/widgets/avatar.dart';
import '../constants.dart';

class BottomNavBarShell extends StatefulWidget {
  final Widget child;

  const BottomNavBarShell({super.key, required this.child});

  @override
  BottomNavBarShellState createState() => BottomNavBarShellState();
}

class BottomNavBarShellState extends State<BottomNavBarShell> {
  static List<Map<String, dynamic>> pages = [
    {'name': 'Home', 'path': '/home', 'icon': Icons.home},
    {'name': 'Roulette', 'path': '/roulette', 'icon': Icons.games},
    {'name': 'Coin Flip', 'path': '/coin-flip', 'icon': Icons.casino},
    {'name': 'Crash', 'path': '/crash', 'icon': Icons.rocket_launch},
    {'name': 'Hi-Lo', 'path': '/hi-lo', 'icon': Icons.card_membership},
    {'name': 'Profile', 'path': '/profile', 'icon': Icons.account_circle},
    {'name': 'Login', 'path': '/login', 'icon': Icons.login},
  ];

  int _selectedIndex = 0;

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
        backgroundColor: AppColors.primary,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AvatarWithFallback(
            imageUrl: 'https://xed.im/img/pingu.jpg',
            radius: 30,
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => GoRouter.of(context).go('/coins'),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: const Row(
                    children: [
                      Text('100', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 5),
                      Icon(Icons.paid, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: pages
            .map(
              (page) => BottomNavigationBarItem(
                icon: Icon(page['icon'], size: 20),
                label: page['name'],
              ),
            )
            .toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray,
        onTap: _onItemTapped,
      ),
    );
  }
}
