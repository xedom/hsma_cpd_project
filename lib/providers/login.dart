import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/providers/auth.dart';

class LoginStatusNotifier extends ChangeNotifier {
  final AuthProvider authProvider;

  LoginStatusNotifier(this.authProvider) {
    authProvider.addListener(_update);
  }

  void _update() {
    notifyListeners();
  }

  bool get isLoggedIn => authProvider.isLoggedIn;

  @override
  void dispose() {
    authProvider.removeListener(_update);
    super.dispose();
  }
}
