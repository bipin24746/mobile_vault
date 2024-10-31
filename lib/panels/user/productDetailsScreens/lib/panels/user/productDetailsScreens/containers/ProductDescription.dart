// product_description.dart
import 'package:flutter/material.dart';

class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}