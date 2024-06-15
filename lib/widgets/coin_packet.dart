// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CoinPacketCard extends StatelessWidget {
  final int amount;
  final double price;
  final String name;

  const CoinPacketCard({
    super.key,
    required this.amount,
    required this.price,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(name, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            Text('Amount: $amount', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 5),
            Text('Price: $price', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
}
