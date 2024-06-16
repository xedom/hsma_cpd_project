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
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: pages
            .map(
              (page) => BottomNavigationBarItem(
                icon: getIconForPage(page['name']!),
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

  Icon getIconForPage(String pageName) {
    switch (pageName) {
      case 'Home':
        return const Icon(Icons.home);
      case 'Roulette':
        return const Icon(Icons.games);
      case 'Coin Flip':
        return const Icon(Icons.casino);
      case 'Crash':
        return const Icon(Icons.rocket_launch);
      case 'Hi-Lo':
        return const Icon(Icons.card_membership);
      case 'Profile':
        return const Icon(Icons.account_circle);
      case 'Login':
        return const Icon(Icons.login);
      default:
        return const Icon(Icons.help);
    }
  }
}
