import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/addbuyproducts.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductDescription.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductImage.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductTitlePrice.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String userId;

  const ProductDetailPage({
    Key? key,
    required this.product,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final productId =
        widget.product['id'] ?? ''; // Default to empty string if null
    final title = widget.product['title'] ?? 'No Title';
    final price = widget.product['price']?.toString() ?? '0';
    final imageUrl =
        widget.product['imageUrl'] ?? ''; // Default to empty string if null
    final description =
        widget.product['description'] ?? 'No Description Available';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                  ProductDescription(
                      description:
                          description), // Ensure description is displayed
                ],
              ),
            ),
          ),
          AddBuyProducts(
            userId: widget.userId,
            productId: productId,
            title: title,
            price: price,
            imageUrl: imageUrl,
            description: description,
          ),
        ],
      ),
    );
  }
}
