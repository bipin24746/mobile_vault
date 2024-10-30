import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/containers/details.dart';
import 'package:mobile_vault/services/database_product.dart';


class ProductsPage extends StatelessWidget {
  final String category;

  ProductsPage({required this.category, required String searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseProduct().viewProducts(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No products found in this category"));
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.all(10),
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
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageUrl != null
                        ? Image.network(
                            imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.grey,
                            child: Center(child: Text("No Image")),
                          ),
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
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Price: Rs. $price",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
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
    );
  }
}
