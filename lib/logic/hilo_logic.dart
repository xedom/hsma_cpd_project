import 'package:hsma_cpd_project/constants.dart';
import 'package:hsma_cpd_project/logic/backend.dart';
import 'package:hsma_cpd_project/providers/auth.dart';

enum GuessType { higher, lower, joker, number, figure, red, black }

class HiLoLogic {
  final List<String> deck = PokerDeckOfCards;

  final BackendService _backendService;
  final AuthProvider _authProvider;
  String currentCard = '';
  String nextCard = '';
  String message = '';
  List<String> previousCards = [];

  HiLoLogic(this._backendService, this._authProvider);

  Future<void> initialize() async {
    currentCard = await _backendService.getHiLoCurrentCard();
  }

  String getBetMultiplier(GuessType guessType) {
    switch (guessType) {
      case GuessType.joker:
        return '25x';
      case GuessType.number:
        return '1.5x';
      case GuessType.figure:
        return '3x';
      case GuessType.red:
      case GuessType.black:
        return '2x';
      case GuessType.higher:
      case GuessType.lower:
        int currentCardValue = getCardValue(currentCard);
        double probability = guessType == GuessType.higher
            ? deck
                    .where((card) => getCardValue(card) >= currentCardValue)
                    .length /
                deck.length
            : deck
                    .where((card) => getCardValue(card) <= currentCardValue)
                    .length /
                deck.length;
        double multiplier = double.parse((1 / probability).toStringAsFixed(2));
        return '${multiplier}x';
      default:
        return '2x';
    }
  }

  Future<void> guess(GuessType guessType, int bet) async {
    if (bet <= 0) {
      message = 'Invalid bet amount';
      return;
    }

    final result = await _backendService.submitHiLoGuess(
        _authProvider.currentUser!, guessType, bet);

    nextCard = result['nextCard'];
    bool correctGuess = result['success'];
    int winnings = result['winnings'];
    // message = result['message'];
    int coins = result['coins'];

    _authProvider.updateCoins(coins);

    if (correctGuess) {
      message = 'Correct! You won $winnings coins.';
    } else {
      message = 'Wrong! You lost $bet coins.';
    }

    previousCards.add(currentCard);
    if (previousCards.length > 10) {
      previousCards.removeAt(0);
    }

    currentCard = nextCard;
  }

  int getCardValue(String card) {
    if (card == 'joker') return 14;
    return int.parse(card.split('_')[1]);
  }
}
