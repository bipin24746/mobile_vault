import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;
  final Color backgroundColor; // Add a customizable background color

  const ProductImage({
    Key? key,
    this.imageUrl,
    this.backgroundColor = Colors.white, // Default background color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 400, // Fixed container height
        width: double.infinity,
        color: backgroundColor, // Set the background color here
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.contain, // Ensures the entire image is visible
              )
            : const Center(child: Text('No Image')),
      ),
    );
  }
}