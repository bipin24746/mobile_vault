import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/user/BuyNowPage.dart';
import 'package:mobile_vault/services/database_product.dart';

class AddBuyProducts extends StatelessWidget {
  final String userId;
  final String productId;
  final String title;
  final String price;
  final String imageUrl;
  final String description;

  const AddBuyProducts({
    required this.userId,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    Key? key,
  }) : super(key: key);

 void _navigateToBuyNowPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuyNowPage(
          product: {
            'title': title,
            'price': price,
            'imageUrl': imageUrl,
            'description': description,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _navigateToBuyNowPage(context),
              child: const Text("Buy Now"),
            ),
          ),
          const SizedBox(width: 16),
          
        ],
      ),
    );
  }
}
