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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Coins Packets',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: coinPackets.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: const Icon(Icons.monetization_on,
                            size: 40, color: Colors.teal),
                        title: Text(
                          coinPackets[index]['name'] as String,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[700],
                          ),
                        ),
                        subtitle: Text(
                          '${coinPackets[index]['amount']} coins',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal[500],
                          ),
                        ),
                        trailing: Text(
                          '\$${(coinPackets[index]['price'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
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
