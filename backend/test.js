const request = require('supertest');
const app = require('./app'); // Your app file

// Mock random number generation for predictable tests
jest.mock('./utils', () => ({
	...jest.requireActual('./utils'), // Import real utilities
	generateGeometric: () => 1.5, // Fixed crash point
	Math: { random: () => 0.2 }, // Simulate coin flips and roulette
}));

describe('Authentication', () => {
	let token;
	const mockUser = { username: 'testuser', password: 'testpassword' };

	it('should register a new user', async () => {
		const res = await request(app).post('/register').send(mockUser);
		expect(res.statusCode).toBe(201);
		expect(res.body).toHaveProperty('token');
		token = res.body.token;
	});

	it('should log in a user', async () => {
		const res = await request(app).post('/login').send(mockUser);
		expect(res.statusCode).toBe(200);
		expect(res.body).toHaveProperty('token');
	});

	it('should return 401 for invalid credentials', async () => {
		const res = await request(app).post('/login').send({ username: 'wrong', password: 'wrong' });
		expect(res.statusCode).toBe(401);
	});

	it('should protect /coins route without token', async () => {
		const res = await request(app).get('/coins');
		expect(res.statusCode).toBe(401);
	});

	it('should protect game routes without token', async () => {
		const res = await request(app).post('/crash/guess').send({ guess: 1.2, bet: 10 });
		expect(res.statusCode).toBe(401);
	});
});

describe('Game Endpoints (with token)', () => {
	let token;

	beforeAll(async () => {
		const res = await request(app).post('/login').send({ username: 'user', password: '1234' });
		token = res.body.token;
	});

	it('should get user coins', async () => {
		const res = await request(app).get('/coins').set('Authorization', token);
		expect(res.statusCode).toBe(200);
		expect(res.body).toHaveProperty('coins');
	});

	it('should play crash game (success)', async () => {
		const res = await request(app).post('/crash/guess').set('Authorization', token).send({ guess: 1.2, bet: 10 });
		expect(res.statusCode).toBe(200);
		expect(res.body.success).toBe(true);
	});

	it('should play crash game (loss)', async () => {
		const res = await request(app).post('/crash/guess').set('Authorization', token).send({ guess: 2.0, bet: 10 });
		expect(res.statusCode).toBe(200);
		expect(res.body.success).toBe(false);
	});

	// Add tests for other game endpoints (roulette, coinflip, hilo)
});

// Tests for error handling (e.g., invalid bets) can be added as well
