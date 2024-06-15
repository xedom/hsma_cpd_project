import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/screens/game_coinflip.dart';
import 'package:hsma_cpd_project/screens/coins.dart';
import 'package:hsma_cpd_project/screens/game_crash.dart';
import 'package:hsma_cpd_project/screens/game_hilo.dart';
import 'package:hsma_cpd_project/screens/game_roulette.dart';
import 'package:hsma_cpd_project/screens/home.dart';
import 'package:hsma_cpd_project/screens/login.dart';
import 'package:hsma_cpd_project/screens/profile.dart';
import 'package:hsma_cpd_project/widgets/app_shell.dart';

void main() {
  runApp(const MyApp());
}

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavBarShell(child: child);
      },
      routes: [
        GoRoute(
          name: 'home',
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          name: 'roulette',
          path: '/roulette',
          builder: (context, state) => const GameRoulettePage(),
        ),
        GoRoute(
          name: 'coin-flip',
          path: '/coin-flip',
          builder: (context, state) => const GameCoinFlipPage(),
        ),
        GoRoute(
          name: 'crash',
          path: '/crash',
          builder: (context, state) => const GameCrashPage(),
        ),
        GoRoute(
          name: 'hi-lo',
          path: '/hi-lo',
          builder: (context, state) => const GameHiLoPage(),
        ),
        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: 'coins',
          path: '/coins',
          builder: (context, state) => CoinsPage(),
        )

        // GoRoute(
        //   path: '/fruits/:id',
        //   builder: (context, state) {
        //     final id = state.pathParameters["id"]! // Get "id" param from URL
        //     return HomePage(id: id);
        //   },
        // ),
      ],
    ),
  ],
);

// path: '/',
// // pageBuilder: (context, state) { return const HomePage(); },
// builder: (context, state) {return Scaffold(appBar: AppBar(title: const Text('Home')),);
// },
// routes: [
//   GoRoute(
//     path: '/login',
//     builder: (context, state) {return Scaffold(appBar: AppBar(title: const Text('Login')));},
//   ),
// ],

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'CPD App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
