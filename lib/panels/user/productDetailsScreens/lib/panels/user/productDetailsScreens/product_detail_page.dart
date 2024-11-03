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
                  const SizedBox(
                      height:
                          20), // Space between description and recommendations
                  _buildRecommendations(title), // Pass title here
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

  Widget _buildRecommendations(String title) {
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

            final allProducts = snapshot.data!.docs;
            final List<Map<String, dynamic>> prioritizedProducts = [];

            // Separate lists for different matching criteria
            final List<Map<String, dynamic>> categoryMatches = [];
            final List<Map<String, dynamic>> brandOrNameMatches = [];
            final List<Map<String, dynamic>> otherProducts = [];

            // Categorizing products
            for (var doc in allProducts) {
              final productData = doc.data() as Map<String, dynamic>;
              final productTags = List<String>.from(productData['tags'] ?? []);
              final productBrand = productData['brand'] ?? '';
              final productCategory = productData['category'] ?? '';
              final productTitle = productData['title'] ?? '';

              // Check if the search is by category
              if (productCategory == category) {
                categoryMatches.add(productData);
              }
              // Check if the search is by brand or specific product name
              else if (productBrand == brand ||
                  (title.isNotEmpty &&
                      productTitle
                          .toLowerCase()
                          .contains(title.toLowerCase()))) {
                brandOrNameMatches.add(productData);
              } else {
                otherProducts.add(productData);
              }
            }

            // Randomly shuffle other products for variety
            otherProducts.shuffle(Random());

            // Combine lists with priority
            prioritizedProducts.addAll(categoryMatches);
            prioritizedProducts.addAll(brandOrNameMatches);
            prioritizedProducts.addAll(otherProducts);

            // Limit the number of products displayed if needed
            // Uncomment below to limit to first 20 products
            // prioritizedProducts = prioritizedProducts.take(20).toList();

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: prioritizedProducts.length,
              itemBuilder: (context, index) {
                final recommendedProduct = prioritizedProducts[index];
                final recommendedProductId = recommendedProduct[
                    'id']; // Ensure 'id' is included in the data
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
