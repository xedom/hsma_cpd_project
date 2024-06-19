import 'dart:async';
import 'dart:math';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:hsma_cpd_project/constants.dart';
import 'package:hsma_cpd_project/logic/hilo_logic.dart' as hilo_logic;
import 'package:hsma_cpd_project/screens/game_coinflip.dart' as game_coinflip;

// enum GuessType { higher, lower, joker, number, figure, red, black }

class BackendService {
  final Map<String, String> _users = {'pedro': '1234', 'john': 'password'};
  final Map<String, int> _userCoins = {'pedro': 100, 'john': 50};

  final String _jwtSecret = 'secret-123456789';

  String? _currentUser;
  String? _currentToken;

  static const List<String> _deck = PokerDeckOfCards;

  String? _lastCard;

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(seconds: 0));
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

  // Coin Flip Game
  Future<Map<String, dynamic>> submitCoinFlipGuess(
      String username, game_coinflip.GuessType guessType, int bet) async {
    await _simulateNetworkDelay();

    if (!_userCoins.containsKey(username) || _userCoins[username]! < bet) {
      return {'success': false, 'message': 'Invalid bet amount'};
    }

    _userCoins[username] = _userCoins[username]! - bet;

    final isHead = Random().nextBool();

    final isCorrect = (isHead && guessType == game_coinflip.GuessType.heads) ||
        (!isHead && guessType == game_coinflip.GuessType.tails);

    if (isCorrect) {
      _userCoins[username] = _userCoins[username]! + (bet * 2);
    }

    return {
      'success': isCorrect,
      'message': isCorrect ? 'You won $bet coins!' : 'You lost $bet coins!',
      'coins': _userCoins[username]!,
    };
  }

  // HiLo Game
  Future<String> getHiLoCurrentCard() async {
    await _simulateNetworkDelay();

    _lastCard = _deck[Random().nextInt(_deck.length)];

    return _lastCard!;
  }

  Future<Map<String, dynamic>> submitHiLoGuess(
      String username, hilo_logic.GuessType guessType, int bet) async {
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
      case hilo_logic.GuessType.higher:
        correctGuess = _getCardValue(nextCard) >= _getCardValue(currentCard!);
        break;
      case hilo_logic.GuessType.lower:
        correctGuess = _getCardValue(nextCard) <= _getCardValue(currentCard!);
        break;
      case hilo_logic.GuessType.joker:
        correctGuess = nextCard == 'joker';
        break;
      case hilo_logic.GuessType.number:
        correctGuess = _isNumber(nextCard);
        break;
      case hilo_logic.GuessType.figure:
        correctGuess = _isFigure(nextCard);
        break;
      case hilo_logic.GuessType.red:
        correctGuess = _isRed(nextCard);
        break;
      case hilo_logic.GuessType.black:
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
      'coins': _userCoins[username]!,
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

  int _getWinnings(hilo_logic.GuessType guessType, int bet) {
    switch (guessType) {
      case hilo_logic.GuessType.joker:
        return bet * 25;

      case hilo_logic.GuessType.number:
        return (bet * 1.5).round();

      case hilo_logic.GuessType.figure:
        return bet * 3;

      case hilo_logic.GuessType.red:
      case hilo_logic.GuessType.black:
        return bet * 2;

      case hilo_logic.GuessType.higher:
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

      case hilo_logic.GuessType.lower:
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
