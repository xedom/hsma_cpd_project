import 'package:flutter_test/flutter_test.dart';
import 'package:hsma_cpd_project/logic/backend.dart';

void main() {
  final service = BackendService();

  group('BackendService', () {
    test('login with valid credentials returns token', () async {
      final token = await service.login('pedro', '1234');
      expect(token, isNotNull);
      expect(service.isLoggedIn(), isTrue);
    });

    test('login with invalid credentials returns null', () async {
    final token = await service.login('invalid', 'credentials');
    expect(token, isNull);
    expect(service.isLoggedIn(), isFalse);
  });

    test('register a new user', () async {
      final success = await service.register('newuser', 'password');
      expect(success, isTrue);
      expect(service.getCoins('newuser'), completion(equals(100)));
    });

    test('add coins to a user', () async {
      await service.addCoins('john', 50);
      expect(service.getCoins('john'), completion(equals(100)));
    });
  });
}