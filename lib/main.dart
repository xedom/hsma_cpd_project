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
import 'package:hsma_cpd_project/constants.dart';

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
          builder: (context, state) => const CoinsPage(),
        )
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
        ),
      ),
      child: MaterialApp.router(
        routerConfig: router,
        title: 'CPD App',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
