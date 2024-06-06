import 'package:flutter/material.dart';
import 'package:hsma_cpd_project/widgets/coin_packet.dart';

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
      appBar: AppBar(
        title: const Text('Coins'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Coins Packets'),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: coinPackets.length,
                  itemBuilder: (context, index) {
                    return CoinPacketCard(
                      amount: coinPackets[index]['amount'] as int,
                      price: coinPackets[index]['price'] as double,
                      name: coinPackets[index]['name'] as String,
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
