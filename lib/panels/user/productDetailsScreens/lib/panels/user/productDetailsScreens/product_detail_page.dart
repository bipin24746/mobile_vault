// product_detail_page.dart
import 'package:flutter/material.dart';

import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/addbuyproducts.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductDescription.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductImage.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductTitlePrice.dart'; // Import the AddBuyProducts widget

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    // Extract product details from widget.product
    final imageUrl = widget.product['imageUrl'];
    final title = widget.product['title'] ?? 'No Title';
    final description =
        widget.product['description'] ?? 'No Description Available';
    final price = widget.product['price']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImage(imageUrl: imageUrl),
                  ProductTitlePrice(title: title, price: price),
                  ProductDescription(description: description),
                  // Add some spacer to ensure scrollability
                  const SizedBox(height: 16), // Optional spacer
                ],
              ),
            ),
          ),
          // Use the new AddBuyProducts widget here
          const AddBuyProducts(),
        ],
      ),
    );
  }
}
