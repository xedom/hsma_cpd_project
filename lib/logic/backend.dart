import 'dart:async';
import 'dart:math';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:hsma_cpd_project/constants.dart' as constants;
import 'package:hsma_cpd_project/logic/hilo_logic.dart' as hilo_logic;
import 'package:hsma_cpd_project/logic/roulette_logic.dart' as roulette_logic;
import 'package:hsma_cpd_project/logic/coinflip_logic.dart' as game_coinflip;

class BackendService {
  final Map<String, String> _users = {'user': '1234', 'user2': 'user2'};
  final Map<String, int> _userCoins = {'user': 100, 'user2': 500};

  final String _jwtSecret = 'secret-123456789';

  String? _currentUser;
  String? _currentToken;

  static const List<String> _deck = constants.pokerDeckOfCards;

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
    } else {
      _currentUser = null;
      _currentToken = null;
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

  // Coin Management
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

  // Crash Game
  Future<Map<String, dynamic>> submitCrashGuess(
      String username, double guess, int bet) async {
    await _simulateNetworkDelay();

    if (!_userCoins.containsKey(username) || _userCoins[username]! < bet) {
      return {'success': false, 'message': 'Invalid bet amount'};
    }

    _userCoins[username] = _userCoins[username]! - bet;

    final crashPoint = _generateGeometric(0.7);
    final success = guess <= crashPoint;

    int winnings = 0;
    if (success) {
      winnings = (bet * (1 + guess)).round();
      _userCoins[username] = _userCoins[username]! + winnings;
    }

    return {
      'success': success,
      'winnings': winnings,
      'crashPoint': crashPoint,
      'coins': _userCoins[username]!,
      'message': success
          ? 'You won $winnings coins! The crash point was $crashPoint.'
          : 'You lost $bet coins! The crash point was $crashPoint.',
    };
  }

  double _generateGeometric(double p) {
    double u = Random().nextDouble();
    return (log(u) / log(1 - p));
  }

  // Roulette Game
  Future<Map<String, dynamic>> submitRouletteGuess(
      String username, roulette_logic.GuessType guess, int bet) async {
    await _simulateNetworkDelay();

    if (!_userCoins.containsKey(username) || _userCoins[username]! < bet) {
      return {'success': false, 'message': 'Invalid bet amount'};
    }

    _userCoins[username] = _userCoins[username]! - bet;

    final int winningNumber = Random().nextInt(37);
    final (int, roulette_logic.GuessType) extractedNumber =
        constants.rouletteNumbers[winningNumber];

    final isCorrect = extractedNumber.$2 == guess;

    int winnings = 0;
    if (isCorrect) {
      switch (guess) {
        case roulette_logic.GuessType.green:
          winnings = bet * 10;
          break;
        case roulette_logic.GuessType.red:
        case roulette_logic.GuessType.black:
          winnings = bet * 2;
          break;
        default:
          winnings = bet * 36;
      }

      _userCoins[username] = _userCoins[username]! + winnings;
    }

    return {
      'success': isCorrect,
      'winnings': winnings,
      'extractedNumber': extractedNumber,
      'coins': _userCoins[username]!,
      'message': isCorrect
          ? 'You won $winnings coins! The extracted number was $extractedNumber.'
          : 'You lost $bet coins! The extracted number was $extractedNumber.',
    };
  }

  // Coin Flip Game
  Future<Map<String, dynamic>> submitCoinFlipGuess(
      String username, game_coinflip.GuessType guess, int bet) async {
    await _simulateNetworkDelay();

    if (!_userCoins.containsKey(username) || _userCoins[username]! < bet) {
      return {'success': false, 'message': 'Invalid bet amount'};
    }

    _userCoins[username] = _userCoins[username]! - bet;

    final isHead = Random().nextBool();

    final isCorrect = (isHead && guess == game_coinflip.GuessType.heads) ||
        (!isHead && guess == game_coinflip.GuessType.tails);

    if (isCorrect) {
      _userCoins[username] = _userCoins[username]! + (bet * 2);
    }

    return {
      'success': isCorrect,
      'coins': _userCoins[username]!,
      'message': isCorrect ? 'You won $bet coins!' : 'You lost $bet coins!',
    };
  }

  // HiLo Game
  Future<String> getHiLoCurrentCard() async {
    await _simulateNetworkDelay();

    _lastCard = _deck[Random().nextInt(_deck.length)];

    return _lastCard!;
  }

  Future<Map<String, dynamic>> submitHiLoGuess(
      String username, hilo_logic.GuessType guess, int bet) async {
    await _simulateNetworkDelay();

    if (!_userCoins.containsKey(username) || _userCoins[username]! < bet) {
      return {'success': false, 'message': 'Invalid bet amount'};
    }

    _userCoins[username] = _userCoins[username]! - bet;
    _lastCard ??= _deck[Random().nextInt(_deck.length)];

    final currentCard = _lastCard;
    final nextCard = _deck[Random().nextInt(_deck.length)];

    bool correctGuess;
    switch (guess) {
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
      winnings = _getWinnings(guess, bet);
      _userCoins[username] = _userCoins[username]! + winnings;
    }

    return {
      'success': correctGuess,
      'winnings': winnings,
      'nextCard': nextCard,
      'coins': _userCoins[username]!,
      'message':
          correctGuess ? 'You won $winnings coins!' : 'You lost $bet coins!',
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
