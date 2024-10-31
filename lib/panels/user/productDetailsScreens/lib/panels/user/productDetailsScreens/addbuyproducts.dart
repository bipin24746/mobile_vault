// addbuyproducts.dart
import 'package:flutter/material.dart';

class AddBuyProducts extends StatelessWidget {
  const AddBuyProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Add your "Buy Now" action here
                print("Buy Now clicked");
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Buy Now"),
            ),
          ),
          const SizedBox(width: 16), // Space between buttons
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Add your "Add to Cart" action here
                print("Add To Cart clicked");
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Add To Cart"),
            ),
          ),
        ],
      ),
    );
  }
}
