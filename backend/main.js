const express = require('express');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');

const {
    rouletteNumbers, pokerDeckOfCards,
    generateGeometric, getCardValue,
    isNumber, isFigure, isRed, getWinnings
} = require('./utils');

const app = express();
const port = 3000;

app.use(bodyParser.json());

const jwtSecret = 'secret-123456789';
const users = {
    user: {
        password: '1234',
        coins: 100,
        lastCard: pokerDeckOfCards[Math.floor(Math.random() * pokerDeckOfCards.length)]
    },
    user2: {
        password: '5678',
        coins: 500,
        lastCard: pokerDeckOfCards[Math.floor(Math.random() * pokerDeckOfCards.length)]
    },
};

const authenticate = (req, res, next) => {
    const token = req.headers['authorization'];
    if (!token) return res.status(401).json({ message: 'Token missing' });

    jwt.verify(token, jwtSecret, (err, decoded) => {
        if (err) return res.status(401).json({ message: 'Invalid token' });

        req.user = decoded;
        next();
    });
};

const game = (req, res, next) => {
    const { guess, bet } = req.body;

    if (!users[req.user.username] || users[req.user.username].coins < bet) {
        return res.status(400).json({ success: false, message: 'Invalid bet amount' });
    }

    users[req.user.username].coins -= bet;

    req.game = {
        guess,
        bet,
        user: req.user.username,
    };

    console.log(`User ${req.user.username} is playing a game with guess "${guess}" and bet "${bet}"`);

    next();
};

app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    if (users[username] && users[username].password === password) {
        return res.json({ token: jwt.sign({ username }, jwtSecret) });
    }
    res.status(401).json({ message: 'Invalid credentials' });
});

app.post('/register', async (req, res) => {
    const { username, password } = req.body;

    if (users[username]) {
        return res.status(400).json({ message: 'User already exists' });
    }

    users[username] = {
        password,
        coins: 100,
        lastCard: pokerDeckOfCards[Math.floor(Math.random() * pokerDeckOfCards.length)]
    };
    res.status(201).json({ token: jwt.sign({ username }, jwtSecret) });
});

app.post('/logout', async (_, res) => {
    res.json({ message: 'Logged out successfully' });
});

app.get('/coins', authenticate, async (req, res) => {
    res.json({ coins: users[req.user.username].coins });
});

app.post('/coins/add', authenticate, async (req, res) => {
    const { amount } = req.body;

    if (!users[req.user.username]) {
        return res.status(400).json({ message: 'User does not exist' });
    }

    users[req.user.username].coins += amount;
    res.json({ coins: users[req.user.username].coins });
});

app.post('/crash/guess', authenticate, game, async (req, res) => {
    const { user, guess, bet } = req.game;

    const crashPoint = generateGeometric(0.7);
    const success = guess <= crashPoint;

    let winnings = 0;
    if (success) {
        winnings = Math.round(bet * guess);
        users[user].coins += bet + winnings;
    }

    res.json({
        success,
        winnings,
        crashPoint,
        coins: users[user].coins,
        message: success
            ? `You won ${winnings} coins! The crash point was ${crashPoint}.`
            : `You lost ${bet} coins! The crash point was ${crashPoint}.`,
    });
});

app.post('/roulette/guess', authenticate, game, async (req, res) => {
    const { user, guess, bet } = req.game;

    const randomNum = Math.floor(Math.random() * 37);
    const extractedNumber = rouletteNumbers[randomNum];
    const success = extractedNumber[1] === guess;

    let winnings = 0;
    if (success) {
        switch (guess) {
            case 'green':
                winnings = bet * (10-1);
                break;
            case 'red':
            case 'black':
                winnings = bet * (2-1);
                break;
            default:
                winnings = bet * (36-1);
        }
        users[user].coins += bet + winnings;
    }

    res.json({
        success,
        winnings,
        extractedNumber,
        coins: users[user].coins,
        message: success
            ? `You won ${winnings} coins! The extracted number was ${extractedNumber[0]}.`
            : `You lost ${bet} coins! The extracted number was ${extractedNumber[0]}.`,
    });
});

app.post('/coinflip/guess', authenticate, game, async (req, res) => {
    const { user, guess, bet } = req.game;

    const isHead = Math.random() >= 0.5;
    const success = (isHead && guess === 'heads') || (!isHead && guess === 'tails');

    if (success) {
        users[user].coins += bet * 2;
    }

    res.json({
        success,
        winnings: success ? bet : 0,
        side: isHead ? 'heads' : 'tails',
        coins: users[user].coins,
        message: success ? `You won ${bet} coins!` : `You lost ${bet} coins!`,
    });
});

app.post('/hilo/guess', authenticate, game, async (req, res) => {
    const { user, guess, bet } = req.game;

    const nextCard = pokerDeckOfCards[Math.floor(Math.random() * pokerDeckOfCards.length)];

    let success = false;
    switch (guess) {
        case 'higher':
            success = getCardValue(nextCard) >= getCardValue(users[user].lastCard);
            break;
        case 'lower':
            success = getCardValue(nextCard) <= getCardValue(users[user].lastCard);
            break;
        case 'joker':
            success = nextCard === 'joker';
            break;
        case 'number':
            success = isNumber(nextCard);
            break;
        case 'figure':
            success = isFigure(nextCard);
            break;
        case 'red':
            success = isRed(nextCard);
            break;
        case 'black':
            success = !isRed(nextCard);
            break;
    }

    let winnings = 0;
    if (success) {
        winnings = getWinnings(guess, bet) - bet;
        users[user].coins += bet + winnings;
    }

    users[user].lastCard = nextCard;

    res.json({
        success: success,
        winnings,
        nextCard,
        coins: users[user].coins,
        message: success ? `You won ${winnings} coins!` : `You lost ${bet} coins!`,
    });
});

app.get('/hilo/current-card', authenticate, async (req, res) => {
    res.json({
        card: users[req.user.username].lastCard,
    });
});

app.listen(port, () => {
    console.log(`Backend service listening at http://localhost:${port}`);
});
