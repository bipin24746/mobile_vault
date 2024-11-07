import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late List<String> tags;
  late String brand;
  late String category;

  @override
  void initState() {
    super.initState();
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
    final productCategory = widget.product['category'] ?? '';

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
              .where('category', isEqualTo: productCategory)
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

            final recommendedProducts = snapshot.data!.docs
                .where((doc) => doc.id != openedProductId)
                .map((doc) {
              final productData = doc.data() as Map<String, dynamic>;
              productData['id'] = doc.id;
              return productData;
            }).toList();

            final categoryMatchingProducts = recommendedProducts
                .where((product) => product['category'] == productCategory)
                .toList();

            if (categoryMatchingProducts.isEmpty) {
              return const Center(
                  child: Text("No products found in this category."));
            }

            categoryMatchingProducts.sort((a, b) {
              int scoreA = _calculateRelevanceScore(a);
              int scoreB = _calculateRelevanceScore(b);
              return scoreB - scoreA;
            });

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: categoryMatchingProducts.length,
                itemBuilder: (context, index) {
                  final recommendedProduct = categoryMatchingProducts[index];
                  final recommendedProductId = recommendedProduct['id'];
                  final recommendedProductTitle = recommendedProduct['title'];
                  final recommendedProductImage =
                      recommendedProduct['imageUrl'];
                  final recommendedProductPrice = recommendedProduct['price'];

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: InkWell(
                      onTap: () {
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12.0)),
                            child: Image.network(
                              recommendedProductImage,
                              width: double.infinity,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              recommendedProductTitle,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Rs. $recommendedProductPrice",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  // Calculate relevance score based on matching brand and tags
  int _calculateRelevanceScore(Map<String, dynamic> product) {
    int score = 0;

    // Increase score for matching brand
    if (product['brand'] == brand) {
      score += 10; // Higher priority for brand match
    }

    // Increase score for matching tags
    List<String> productTags = List<String>.from(product['tags'] ?? []);
    for (String tag in tags) {
      if (productTags.contains(tag)) {
        score += 5; // Moderate priority for tag match
      }
    }

    return score;
  }

  // Check if the product matches the current brand
  bool _matchesBrand(Map<String, dynamic> product) {
    return product['brand'] == brand; // Match brand
  }

  // Check if the product matches any of the tags
  bool _matchesTags(Map<String, dynamic> product) {
    List<String> productTags = List<String>.from(product['tags'] ?? []);
    for (String tag in tags) {
      if (productTags.contains(tag)) {
        return true; // Match any tag
      }
    }
    return false;
  }
}
