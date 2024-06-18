import 'dart:async';
import 'dart:math';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

enum GuessType { higher, lower, joker, number, figure, red, black }

class BackendService {
  final Map<String, String> _users = {'pedro': '1234', 'john': 'password'};
  final Map<String, int> _userCoins = {'pedro': 100, 'john': 50};

  final String _jwtSecret = 'secret-123456789';

  String? _currentUser;
  String? _currentToken;

  static const List<String> _deck = [
    'clubs_1',
    'clubs_2',
    'clubs_3',
    'clubs_4',
    'clubs_5',
    'clubs_6',
    'clubs_7',
    'clubs_8',
    'clubs_9',
    'clubs_10',
    'clubs_11',
    'clubs_12',
    'clubs_13',
    'diamonds_1',
    'diamonds_2',
    'diamonds_3',
    'diamonds_4',
    'diamonds_5',
    'diamonds_6',
    'diamonds_7',
    'diamonds_8',
    'diamonds_9',
    'diamonds_10',
    'diamonds_11',
    'diamonds_12',
    'diamonds_13',
    'hearts_1',
    'hearts_2',
    'hearts_3',
    'hearts_4',
    'hearts_5',
    'hearts_6',
    'hearts_7',
    'hearts_8',
    'hearts_9',
    'hearts_10',
    'hearts_11',
    'hearts_12',
    'hearts_13',
    'spades_1',
    'spades_2',
    'spades_3',
    'spades_4',
    'spades_5',
    'spades_6',
    'spades_7',
    'spades_8',
    'spades_9',
    'spades_10',
    'spades_11',
    'spades_12',
    'spades_13',
    'joker'
  ];

  String? _lastCard;

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<String?> login(String username, String password) async {
    await _simulateNetworkDelay();

    if (_users.containsKey(username) && _users[username] == password) {
      _currentUser = username;

      final jwt = JWT({'username': username}, issuer: 'flutter_app');

      _currentToken = jwt.sign(SecretKey(_jwtSecret));
      return _currentToken;
    }
    return null;
  }

  Future<bool> register(String username, String password) async {
    await _simulateNetworkDelay();

    if (_users.containsKey(username)) {
      return false;
    }

    _users[username] = password;
    _userCoins[username] = 100;
    return true;
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

  Future<int> getCoins(String username) async {
    await _simulateNetworkDelay();

    if (_userCoins.containsKey(username)) {
      return _userCoins[username]!;
    }
    return 0;
  }

  Future<bool> addCoins(String username, int amount) async {
    await _simulateNetworkDelay();

    if (_userCoins.containsKey(username)) {
      _userCoins[username] = _userCoins[username]! + amount;
      return true;
    }
    return false;
  }

  Future<bool> updateCoins(String username, int amount) async {
    await _simulateNetworkDelay();

    if (_userCoins.containsKey(username)) {
      _userCoins[username] = _userCoins[username]! + amount;
      return true;
    }
    return false;
  }

  Future<String> getHiLoCurrentCard() async {
    await _simulateNetworkDelay();

    _lastCard = _deck[Random().nextInt(_deck.length)];

    return _lastCard!;
  }

  Future<Map<String, dynamic>> processHiLoGuess(
      String username, GuessType guessType, int bet) async {
    await _simulateNetworkDelay();

    if (!_userCoins.containsKey(username) || _userCoins[username]! < bet) {
      return {'success': false, 'message': 'Invalid bet amount'};
    }

    _userCoins[username] = _userCoins[username]! - bet;
    _lastCard ??= _deck[Random().nextInt(_deck.length)];

    final currentCard = _lastCard;
    final nextCard = _deck[Random().nextInt(_deck.length)];

    bool correctGuess;
    switch (guessType) {
      case GuessType.higher:
        correctGuess = _getCardValue(nextCard) >= _getCardValue(currentCard!);
        break;
      case GuessType.lower:
        correctGuess = _getCardValue(nextCard) <= _getCardValue(currentCard!);
        break;
      case GuessType.joker:
        correctGuess = nextCard == 'joker';
        break;
      case GuessType.number:
        correctGuess = _isNumber(nextCard);
        break;
      case GuessType.figure:
        correctGuess = _isFigure(nextCard);
        break;
      case GuessType.red:
        correctGuess = _isRed(nextCard);
        break;
      case GuessType.black:
        correctGuess = !_isRed(nextCard);
        break;
    }

    int winnings = 0;
    if (correctGuess) {
      winnings = _getWinnings(guessType, bet);
      _userCoins[username] = _userCoins[username]! + winnings;
    }

    return {
      'success': correctGuess,
      'message':
          correctGuess ? 'You won $winnings coins!' : 'You lost $bet coins!',
      'winnings': winnings,
      'nextCard': nextCard,
    };
  }

  int _getCardValue(String card) {
    if (card == 'joker') return 14;
    return int.parse(card.split('_')[1]);
  }

  bool _isNumber(String card) {
    if (card == 'joker') return false;
    int value = int.parse(card.split('_')[1]);
    return value >= 2 && value <= 9;
  }

  bool _isFigure(String card) {
    if (card == 'joker') return false;
    int value = int.parse(card.split('_')[1]);
    return value == 1 || value >= 11;
  }

  bool _isRed(String card) {
    return card.startsWith('hearts') || card.startsWith('diamonds');
  }

  int _getWinnings(GuessType guessType, int bet) {
    switch (guessType) {
      case GuessType.joker:
        return bet * 10;

      case GuessType.number:
        return (bet * 1.5).round();

      case GuessType.figure:
        return bet * 3;

      case GuessType.red:
      case GuessType.black:
        return bet * 2;

      case GuessType.higher:
        {
          int currentCardValue = _getCardValue(_lastCard!);
          double probability = _deck
                  .where((card) => _getCardValue(card) >= currentCardValue)
                  .length /
              _deck.length;
          double multiplier =
              double.parse((1 / probability).toStringAsFixed(2));
          return (bet * multiplier).round();
        }

      case GuessType.lower:
        {
          int currentCardValue = _getCardValue(_lastCard!);
          double probability = _deck
                  .where((card) => _getCardValue(card) <= currentCardValue)
                  .length /
              _deck.length;
          double multiplier =
              double.parse((1 / probability).toStringAsFixed(2));
          return (bet * multiplier).round();
        }

      default:
        return bet * 2;
    }
  }
}
