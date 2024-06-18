import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/coin_packet_card.dart';
import '../providers/auth.dart';

class CoinsPage extends StatelessWidget {
  const CoinsPage({super.key});

  final coinPackets = const [
    {'amount': 10, 'price': 1.0, 'name': 'Bronze'},
    {'amount': 50, 'price': 4.5, 'name': 'Silver'},
    {'amount': 100, 'price': 8.0, 'name': 'Gold'},
    {'amount': 500, 'price': 35.0, 'name': 'Platinum'},
    {'amount': 1000, 'price': 70.0, 'name': 'Diamond'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Coins Packets',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: coinPackets.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CoinPacketCard(
                          amount: coinPackets[index]['amount'] as int,
                          price: coinPackets[index]['price'] as double,
                          name: coinPackets[index]['name'] as String,
                          onTap: () => _addCoins(
                              context, coinPackets[index]['amount'] as int),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCoins(BuildContext context, int amount) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.addCoins(amount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $amount coins to your account!')),
    );
  }
}
