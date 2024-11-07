// product_title_price.dart
import 'package:flutter/material.dart';

class ProductTitlePrice extends StatelessWidget {
  final String title;
  final String price;

  const ProductTitlePrice({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Price: Rs. $price",
          style: const TextStyle(fontSize: 20, color: Colors.blueAccent),
        ),
      ],
    );
  }
}
