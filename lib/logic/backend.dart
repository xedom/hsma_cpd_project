import 'dart:async';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class BackendService {
  final Map<String, String> _users = {'pedro': '1234', 'john': 'password'};

  final String _jwtSecret = 'secret-123456789';

  String? _currentUser;
  String? _currentToken;

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<String?> login(String username, String password) async {
    await _simulateNetworkDelay();

    if (_users.containsKey(username) && _users[username] == password) {
      _currentUser = username;

      final jwt = JWT(
        {'username': username},
        issuer: 'flutter_app',
      );

      _currentToken = jwt.sign(SecretKey(_jwtSecret));
      return _currentToken;
    }
    return null;
  }

  Future<void> logout() async {
    await _simulateNetworkDelay();
    _currentUser = null;
    _currentToken = null;
  }

  bool isLoggedIn() {
    return _currentUser != null;
  }

  String? getCurrentUser() {
    return _currentUser;
  }

  bool verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_jwtSecret));
      return jwt.payload['username'] == _currentUser;
    } catch (e) {
      return false;
    }
  }
}
