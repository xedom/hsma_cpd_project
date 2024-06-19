import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/logic/backend.dart';

class AuthProvider extends ChangeNotifier {
  final BackendService _backendService;
  bool _isLoggedIn = false;
  String? _token;
  int _coins = 0;

  AuthProvider(this._backendService);

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  int get coins => _coins;

  Future<bool> login(String username, String password) async {
    String? token = await _backendService.login(username, password);
    if (token != null) {
      _isLoggedIn = true;
      _token = token;
      _coins = await _backendService.getCoins(username);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    bool success = await _backendService.register(username, password);
    if (success) {
      return await login(username, password);
    }
    return false;
  }

  Future<void> logout() async {
    await _backendService.logout();
    _isLoggedIn = false;
    _token = null;
    _coins = 0;
    notifyListeners();
  }

  String? get currentUser => _backendService.getCurrentUser();

  bool verifyToken(String token) {
    return _backendService.verifyToken(token);
  }

  Future<void> fetchCoins() async {
    if (currentUser != null) {
      _coins = await _backendService.getCoins(currentUser!);
      notifyListeners();
    }
  }

  void updateCoins(int newCoins) {
    _coins = newCoins;
    notifyListeners();
  }

  void addCoins(int amount) async {
    await _backendService.addCoins(currentUser!, amount);
    _coins += amount;
    notifyListeners();
  }
}
