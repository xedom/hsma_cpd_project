import 'package:flutter/material.dart';

class CoinsPage extends StatelessWidget {
  CoinsPage({super.key});

  final coinPackets = [
    {'amount': 10, 'price': 1.0, 'name': 'Bronze'},
    {'amount': 50, 'price': 4.5, 'name': 'Silver'},
    {'amount': 100, 'price': 8.0, 'name': 'Gold'},
    {'amount': 500, 'price': 35.0, 'name': 'Platinum'},
    {'amount': 1000, 'price': 70.0, 'name': 'Diamond'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Coins Packets',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: coinPackets.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 40,
                            color: Colors.teal,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  coinPackets[index]['name'] as String,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${coinPackets[index]['amount']} coins',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.teal[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${(coinPackets[index]['price'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
