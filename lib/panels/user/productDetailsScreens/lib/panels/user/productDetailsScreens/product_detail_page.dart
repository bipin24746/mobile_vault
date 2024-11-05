import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/addbuyproducts.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductDescription.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductImage.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductTitlePrice.dart';
import 'dart:math'; // Import to use Random for shuffling

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
  late List<String> tags;
  late String brand;
  late String category;

  @override
  void initState() {
    super.initState();
    // Extracting tags, brand, and category from the product
    tags = List<String>.from(widget.product['tags'] ?? []);
    brand = widget.product['brand'] ?? '';
    category = widget.product['category'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final productId = widget.product['id'] ?? '';
    final title = widget.product['title'] ?? 'No Title';
    final price = widget.product['price']?.toString() ?? '0';
    final imageUrl = widget.product['imageUrl'] ?? '';
    final description =
        widget.product['description'] ?? 'No Description Available';
    final productCategory =
        widget.product['category'] ?? ''; // Get category dynamically

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
                  ProductDescription(description: description),
                  const SizedBox(height: 20),
                  _buildRecommendations(title, productCategory, productId),
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

  Widget _buildRecommendations(
      String title, String productCategory, String openedProductId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "Recommended Products",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Evault Products')
              .where('category',
                  isEqualTo: productCategory) // Filter by current category
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No recommendations found."));
            }

            // Exclude the currently viewed product from recommendations
            final recommendedProducts = snapshot.data!.docs
                .where((doc) =>
                    doc.id != openedProductId) // Exclude opened product
                .map((doc) {
              final productData = doc.data() as Map<String, dynamic>;
              productData['id'] = doc.id; // Add document ID to product data
              return productData;
            }).toList();

            if (recommendedProducts.isEmpty) {
              return const Center(
                  child: Text("No other products available in this category."));
            }

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recommendedProducts.length,
              itemBuilder: (context, index) {
                final recommendedProduct = recommendedProducts[index];
                final recommendedProductId = recommendedProduct['id'];
                final recommendedProductTitle = recommendedProduct['title'];
                final recommendedProductImage = recommendedProduct['imageUrl'];
                final recommendedProductPrice = recommendedProduct['price'];

                return ListTile(
                  leading: Image.network(recommendedProductImage,
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(recommendedProductTitle),
                  subtitle: Text("Price: Rs. $recommendedProductPrice"),
                  onTap: () {
                    // Navigate to the detail page of the recommended product
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: {
                            ...recommendedProduct,
                            'id': recommendedProductId,
                          },
                          userId: widget.userId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
