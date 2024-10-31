import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/product_detail_page.dart';

import 'package:mobile_vault/services/database_product.dart';

class CategoriesProducts extends StatelessWidget {
  final String category; // Receive category as a parameter

  const CategoriesProducts({Key? key, required this.category})
      : super(key: key); // Constructor to accept category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products in $category",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: DatabaseProduct()
                    .viewProducts(category), // Use the passed category
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No products found in this category",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final products = snapshot.data!.docs;

                  return GridView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product =
                          products[index].data() as Map<String, dynamic>;
                      final imageUrl = product['imageUrl'];
                      final title = product['title'] ?? 'No Title';
                      final price = product['price']?.toString() ?? '0';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                        child: IntrinsicHeight(
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: imageUrl != null
                                      ? Image.network(
                                          imageUrl,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                        )
                                      : Container(
                                          height: 150,
                                          width: double.infinity,
                                          color: Colors.grey[200],
                                          child:
                                              Center(child: Text("No Image")),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1, // Display up to 1 lines
                                        overflow: TextOverflow
                                            .ellipsis, // Truncate overflowed text
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
