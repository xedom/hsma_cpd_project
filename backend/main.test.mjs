import request from 'supertest';
import app from './main.js';
import { describe, it, expect, beforeAll } from 'vitest';

// jest.mock('jsonwebtoken', () => ({
// 	sign: (payload) => `mocked_token_${payload.username}`,
// 	verify: (token, secret, callback) => {
// 		const username = token.split('_')[2];
// 		callback(null, { username });
// 	},
// }));

describe.concurrent('Authentication Endpoints', () => {
	it('POST /login - successful login', async () => {
		const res = await request(app).post('/login').send({ username: 'user', password: '1234' });

		expect(res.status).toBe(200);
		expect(res.body).toHaveProperty('token');
	});

	it('POST /login - incorrect password', async () => {
		const res = await request(app).post('/login').send({ username: 'user', password: 'wrong-password' });

		expect(res.status).toBe(401);
		expect(res.body).toHaveProperty('message', 'Invalid credentials');
	});

	it('POST /register - successful registration', async () => {
		const res = await request(app).post('/register').send({ username: 'newUser', password: 'newPassword' });

		expect(res.status).toBe(201);
		expect(res.body).toHaveProperty('token');
	});

	it('POST /register - user already exists', async () => {
		const res = await request(app).post('/register').send({ username: 'user', password: '1234' });

		expect(res.status).toBe(400);
		expect(res.body).toHaveProperty('message', 'User already exists');
	});

	it('POST /logout', async () => {
		const resLogin = await request(app).post('/login').send({ username: 'user', password: '1234' });

		const res = await request(app).post('/logout').set('Authorization', resLogin.body.token);

		expect(res.status).toBe(200);
		expect(res.body).toHaveProperty('message', 'Logged out successfully');
	});
});

describe('Protected Endpoints (require authentication)', () => {
	let token;

	beforeAll(async () => {
		const res = await request(app).post('/login').send({ username: 'user', password: '1234' });
		token = res.body.token;
	});

	it('GET /coins should return user coins', async () => {
		const res = await request(app).get('/coins').set('Authorization', token);
		expect(res.statusCode).toBe(200);
		expect(res.body).toHaveProperty('coins');
	});

	it('POST /coins/add should add coins and return new balance', async () => {
		const res = await request(app).post('/coins/add').set('Authorization', token).send({ amount: 50 });
		expect(res.statusCode).toBe(200);
		expect(res.body.coins).toBeGreaterThanOrEqual(150);
	});

	describe('Game Endpoints', () => {
		let token;

		beforeAll(async () => {
			const res = await request(app).post('/login').send({ username: 'user', password: '1234' });
			token = res.body.token;
		});

		it('POST /crash/guess should play crash game', async () => {
			const res = await request(app).post('/crash/guess').set('Authorization', token).send({ guess: 1.5, bet: 10 });
			expect(res.statusCode).toBe(200);
			expect(res.body).toHaveProperty('success');
			expect(res.body).toHaveProperty('winnings');
		});

		describe('POST /crash/guess', () => {
			it('should play crash game', (done) => {
				request(app)
					.post('/crash/guess')
					.set('Authorization', token)
					.send({ guess: 1.5, bet: 10 })
					.expect(200)
					.end((err, res) => {
						if (err) return done(err);
						expect(res.body).to.have.property('success');
						expect(res.body).to.have.property('winnings');
						expect(res.body).to.have.property('crashPoint');
						expect(res.body).to.have.property('coins');
						done();
					});
			});
		});

		describe('POST /roulette/guess', () => {
			it('should play roulette game', (done) => {
				request(app)
					.post('/roulette/guess')
					.set('Authorization', token)
					.send({ guess: 'red', bet: 10 })
					.expect(200)
					.end((err, res) => {
						if (err) return done(err);
						expect(res.body).to.have.property('success');
						expect(res.body).to.have.property('winnings');
						expect(res.body).to.have.property('extractedNumber');
						expect(res.body).to.have.property('coins');
						done();
					});
			});
		});

		describe('POST /coinflip/guess', () => {
			it('should play coinflip game', (done) => {
				request(app)
					.post('/coinflip/guess')
					.set('Authorization', token)
					.send({ guess: 'heads', bet: 10 })
					.expect(200)
					.end((err, res) => {
						if (err) return done(err);
						expect(res.body).to.have.property('success');
						expect(res.body).to.have.property('winnings');
						expect(res.body).to.have.property('side');
						expect(res.body).to.have.property('coins');
						done();
					});
			});
		});

		describe('POST /hilo/guess', () => {
			it('should play hilo game', (done) => {
				request(app)
					.post('/hilo/guess')
					.set('Authorization', token)
					.send({ guess: 'higher', bet: 10 })
					.expect(200)
					.end((err, res) => {
						if (err) return done(err);
						expect(res.body).to.have.property('success');
						expect(res.body).to.have.property('winnings');
						expect(res.body).to.have.property('nextCard');
						expect(res.body).to.have.property('coins');
						done();
					});
			});
		});

		describe('GET /hilo/current-card', () => {
			it('should return the current card', (done) => {
				request(app)
					.get('/hilo/current-card')
					.set('Authorization', token)
					.expect(200)
					.end((err, res) => {
						if (err) return done(err);
						expect(res.body).to.have.property('card');
						done();
					});
			});
		});
	});
});
