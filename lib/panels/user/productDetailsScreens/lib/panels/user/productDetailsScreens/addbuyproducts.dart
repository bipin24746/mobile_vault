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

  AddBuyProducts({
    required this.userId,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    Key? key,
    required this.description,
  }) : super(key: key);

  void _addToCart(BuildContext context) async {
    // Check if the product is already in the cart
    bool isInCart = await DatabaseProduct().checkIfInCart(userId, productId);
    
    if (isInCart) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Already in cart"),
      ));
    } else {
      // If not in cart, add it
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
            // Add other product fields if needed
          },
          userId: userId,
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
              onPressed: () => _navigateToBuyNowPage(context), // Navigate to BuyNowPage
              child: const Text("Buy Now"),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _addToCart(context), // Add to cart logic
              child: const Text("Add To Cart"),
            ),
          ),
        ],
      ),
    );
  }
}
