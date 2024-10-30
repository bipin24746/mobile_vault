// product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/containers/ProductDescription.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/containers/ProductImage.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/containers/ProductTitlePrice.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = product['imageUrl'];
    final title = product['title'] ?? 'No Title';
    final description = product['description'] ?? 'No Description Available';
    final price = product['price']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImage(imageUrl: imageUrl),
            ProductTitlePrice(title: title, price: price),
            ProductDescription(description: description),
          ],
        ),
      ),
    );
  }
}
