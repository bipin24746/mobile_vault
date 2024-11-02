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

  void _addToCart(BuildContext context) async {
    bool isInCart = await DatabaseProduct().checkIfInCart(userId, productId);

    if (isInCart) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Already in cart"),
      ));
    } else {
      await DatabaseProduct().addToCart(userId, productId, title, price, imageUrl, description);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added to cart"),
      ));
    }
  }

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
