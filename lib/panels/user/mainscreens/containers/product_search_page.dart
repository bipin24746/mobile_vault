import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/details.dart';

import 'package:mobile_vault/services/database_product.dart';

class ProductSearchPage extends StatelessWidget {
  final String searchQuery;

  const ProductSearchPage({Key? key, required this.searchQuery})
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
        stream: DatabaseProduct().viewProducts('',
            searchQuery: searchQuery), // Pass an empty category
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

          // Filter products based on search query in title or tags
          final products = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final title = data['title'] ?? '';
            final tags = (data['tags'] as List?)
                    ?.map((tag) => tag.toString().toLowerCase()) ??
                [];
            final lowerQuery = searchQuery.toLowerCase();

            // Check if query is in title or tags
            final titleMatches = title.toLowerCase().contains(lowerQuery);
            final tagsMatch = tags.any((tag) => tag.contains(lowerQuery));

            return titleMatches || tagsMatch;
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
