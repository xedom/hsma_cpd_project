import 'package:flutter/material.dart';
import '../constants.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.monetization_on,
            size: 40,
            color: AppColors.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$amount coins',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
