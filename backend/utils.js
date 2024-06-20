module.exports = {
    rouletteNumbers: [
        ['green', '0'], ['black', '2'],
        ['red', '3'], ['black', '4'],
        ['red', '5'], ['black', '6'],
        ['red', '7'], ['black', '8'],
        ['red', '9'], ['black', '10'], ['black', '11'],
        ['red', '12'], ['black', '13'],
        ['red', '14'], ['black', '15'],
        ['red', '16'], ['black', '17'],
        ['red', '18'],
        ['red', '19'], ['black', '20'],
        ['red', '21'], ['black', '22'],
        ['red', '23'], ['black', '24'],
        ['red', '25'], ['black', '26'],
        ['red', '27'], ['black', '28'], ['black', '29'],
        ['red', '30'], ['black', '31'],
        ['red', '32'], ['black', '33'],
        ['red', '34'], ['black', '35'],
        ['red', '36'],
    ],

    pokerDeckOfCards: [
        'hearts_2', 'hearts_3', 'hearts_4', 'hearts_5', 'hearts_6', 'hearts_7', 'hearts_8', 'hearts_9', 'hearts_10', 'hearts_11', 'hearts_12', 'hearts_13', 'hearts_14',
        'diamonds_2', 'diamonds_3', 'diamonds_4', 'diamonds_5', 'diamonds_6', 'diamonds_7', 'diamonds_8', 'diamonds_9', 'diamonds_10', 'diamonds_11', 'diamonds_12', 'diamonds_13', 'diamonds_14',
        'clubs_2', 'clubs_3', 'clubs_4', 'clubs_5', 'clubs_6', 'clubs_7', 'clubs_8', 'clubs_9', 'clubs_10', 'clubs_11', 'clubs_12', 'clubs_13', 'clubs_14',
        'spades_2', 'spades_3', 'spades_4', 'spades_5', 'spades_6', 'spades_7', 'spades_8', 'spades_9', 'spades_10', 'spades_11', 'spades_12', 'spades_13', 'spades_14',
        'joker',
    ],

    // Coin Flip Game
    generateGeometric(p) {
        const u = Math.random();
        return Math.log(u) / Math.log(1 - p);
    },

    // HiLo Game
    getCardValue(card) {
        if (card === 'joker') return 14;
        return parseInt(card.split('_')[1]);
    },
    
    isNumber(card) {
        if (card === 'joker') return false;
        const value = parseInt(card.split('_')[1]);
        return value >= 2 && value <= 9;
    },
    
    isFigure(card) {
        if (card === 'joker') return false;
        const value = parseInt(card.split('_')[1]);
        return value === 1 || value >= 11;
    },
    
    isRed(card) {
        return card.startsWith('hearts') || card.startsWith('diamonds');
    },
    
    getWinnings(guessType, bet) {
        switch (guessType) {
            case 'joker':
                return bet * 25;
            case 'number':
                return Math.round(bet * 1.5);
            case 'figure':
                return bet * 3;
            case 'red':
            case 'black':
                return bet * 2;
            case 'higher':
                return calculateMultiplier(bet, guessType);
            case 'lower':
                return calculateMultiplier(bet, guessType);
            default:
                return bet * 2;
        }
    },
    
    calculateMultiplier(bet, guessType) {
        const currentCardValue = getCardValue(_lastCard);
        const probability = constants.pokerDeckOfCards.filter((card) => {
            if (guessType === 'higher') return getCardValue(card) >= currentCardValue;
            if (guessType === 'lower') return getCardValue(card) <= currentCardValue;
        }).length / constants.pokerDeckOfCards.length;
    
        const multiplier = parseFloat((1 / probability).toFixed(2));
        return Math.round(bet * multiplier);
    },
}