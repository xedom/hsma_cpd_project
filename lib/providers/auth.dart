import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/backend.dart';

class AuthProvider extends ChangeNotifier {
  final BackendService _backendService = BackendService();
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  Future<bool> login(String username, String password) async {
    String? token = await _backendService.login(username, password);
    if (token != null) {
      _isLoggedIn = true;
      _token = token;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _backendService.logout();
    _isLoggedIn = false;
    _token = null;
    notifyListeners();
  }

  String? get currentUser => _backendService.getCurrentUser();

  bool verifyToken(String token) {
    return _backendService.verifyToken(token);
  }
}
