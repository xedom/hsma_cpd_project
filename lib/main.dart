import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsma_cpd_project/screens/home.dart';
import 'package:hsma_cpd_project/screens/login.dart';
import 'package:hsma_cpd_project/screens/profile.dart';
import 'package:hsma_cpd_project/widgets/bottom_navbar_shell.dart';

void main() {
  runApp(const MyApp());
  // runApp(MaterialApp.router(routerConfig: router));
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
          name:
              'home', // Optional, add name to your routes. Allows you navigate by name instead of path
          path: '/home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: 'profile',
          path: '/profile',
          builder: (context, state) => ProfilePage(),
        ),
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

// final router = GoRouter(
//   initialLocation: '/',
//   routes: [
//     GoRoute(
//       path: '/',
//       // pageBuilder: (context, state) { return const HomePage(); },
//       builder: (context, state) {return Scaffold(appBar: AppBar(title: const Text('Home')),);
//       },
//       routes: [
//         GoRoute(
//           path: '/login',
//           builder: (context, state) {return Scaffold(appBar: AppBar(title: const Text('Login')));},
//         ),
//         GoRoute(
//           path: '/home',
//           builder: (context, state) {return Scaffold(appBar: AppBar(title: const Text('Home2')));},
//         ),
//       ],
//     ),
//   ],
// );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'CPD App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: const MyHomePage(title: 'CPD App Home Page'),
      // home: const LoginScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
