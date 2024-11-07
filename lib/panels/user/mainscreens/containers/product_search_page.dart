import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/details.dart';

import 'package:mobile_vault/services/database_product.dart';

class ProductSearchPage extends StatelessWidget {
  final String searchQuery;
  final String category;
  final String brand;

  const ProductSearchPage(
      {Key? key,
      required this.searchQuery,
      required this.category,
      required this.brand})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Results for '$searchQuery'",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseProduct().viewProducts(
          category: category,
          brand: brand,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child:
                    Text("No products found", style: TextStyle(fontSize: 18)));
          }

          // Remove spaces from search query
          final lowerQuery = searchQuery.replaceAll(' ', '').toLowerCase();

          // Filter products based on search query in title, brand, category, or tags
          final products = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final title = data['title']?.toString().toLowerCase() ?? '';
            final tags = (data['tags'] as List<dynamic>?)
                    ?.map((tag) => tag.toString().toLowerCase()) ??
                [];
            final docCategory =
                data['category']?.toString().toLowerCase() ?? '';
            final docBrand = data['brand']?.toString().toLowerCase() ?? '';

            // Match if searchQuery is found in any part of title, tags, category, or brand
            final titleMatches = title.replaceAll(' ', '').contains(lowerQuery);
            final tagsMatch =
                tags.any((tag) => tag.replaceAll(' ', '').contains(lowerQuery));
            final categoryMatch =
                docCategory.replaceAll(' ', '').contains(lowerQuery);
            final brandMatch =
                docBrand.replaceAll(' ', '').contains(lowerQuery);

            // Show the product if there’s a match in any field
            return titleMatches || tagsMatch || categoryMatch || brandMatch;
          }).toList();

          if (products.isEmpty) {
            return Center(
                child: Text("No products match your search.",
                    style: TextStyle(fontSize: 18)));
          }

          return GridView.builder(
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = products[index].data() as Map<String, dynamic>;
              final imageUrl = product['imageUrl'];
              final title = product['title'] ?? 'No Title';
              final price = product['price']?.toString() ?? '0';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                          product: product,
                          userId: ''), // Replace with actual userId
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(imageUrl,
                              height: 110,
                              width: double.infinity,
                              fit: BoxFit.cover),
                        )
                      else
                        Container(height: 70, color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Rs. $price",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.red, // Price in red for emphasis
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
