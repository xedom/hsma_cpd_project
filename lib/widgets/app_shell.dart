import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/widgets/avatar.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/providers/auth.dart';
import 'package:hsma_cpd_project/constants.dart';

class BottomNavBarShell extends StatefulWidget {
  final Widget child;

  const BottomNavBarShell({super.key, required this.child});

  @override
  BottomNavBarShellState createState() => BottomNavBarShellState();
}

class BottomNavBarShellState extends State<BottomNavBarShell> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> pages = [];

  @override
  void initState() {
    super.initState();
    final currentLocation =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    _selectedIndex = _getPageIndexFromPath(currentLocation);
  }

  int _getPageIndexFromPath(String path) {
    return pages.indexWhere((page) => page['path'] == path);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    GoRouter.of(context).go(pages[index]['path']!);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    pages = [
      {'name': 'Roulette', 'path': '/roulette', 'icon': Icons.games},
      {'name': 'Coin Flip', 'path': '/coin-flip', 'icon': Icons.casino},
      {'name': 'Crash', 'path': '/crash', 'icon': Icons.rocket_launch},
      {'name': 'Hi-Lo', 'path': '/hi-lo', 'icon': Icons.card_membership},
      if (authProvider.isLoggedIn)
        {'name': 'Profile', 'path': '/profile', 'icon': Icons.account_circle}
      else
        {'name': 'Login', 'path': '/login', 'icon': Icons.login},
    ];

    _selectedIndex = _getPageIndexFromPath(
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: authProvider.isLoggedIn
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: AvatarWithFallback(
                  imageUrl: 'https://xed.im/img/pingu.jpg',
                  radius: 30,
                ),
              )
            : null,
        title: const SizedBox.shrink(),
        actions: [
          if (authProvider.isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => GoRouter.of(context).go('/coins'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Row(
                      children: [
                        Text('${authProvider.coins}',
                            style: const TextStyle(color: Colors.white)),
                        const SizedBox(width: 5),
                        const Icon(Icons.paid, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.primary,
            items: pages
                .map(
                  (page) => BottomNavigationBarItem(
                    icon: Icon(page['icon'], size: 24),
                    label: page['name'],
                  ),
                )
                .toList(),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: AppColors.primaryLight,
            onTap: (index) {
              if (pages[index]['path'] == '/profile' &&
                  !authProvider.isLoggedIn) {
                GoRouter.of(context).go('/login');
              } else {
                _onItemTapped(index);
              }
            },
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
