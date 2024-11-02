import 'package:flutter/material.dart';
import 'package:mobile_vault/services/database_product.dart';

class AddBuyProducts extends StatelessWidget {
  final String userId;
  final String productId;
  final String title;
  final String price;
  final String imageUrl;
  final String description;

  AddBuyProducts({
    required this.userId,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    Key? key,
    required this.description,
  }) : super(key: key);

  void _addToCart(BuildContext context) {
    DatabaseProduct()
        .addToCart(userId, productId, title, price, imageUrl, description);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Added to cart"),
    ));
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
              onPressed: () {
                // Handle "Buy Now" action here if needed
                print("Buy Now clicked");
              },
              child: const Text("Buy Now"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _addToCart(context),
              child: const Text("Add To Cart"),
            ),
          ),
        ],
      ),
    );
  }
}
