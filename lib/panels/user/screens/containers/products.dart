import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_vault/services/database_product.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.red, // Set the background color to red
        child: StreamBuilder<QuerySnapshot>(
          stream: DatabaseProduct()
              .viewProducts(), // Stream of products from Firestore
          builder: (context, snapshot) {
            // Check the connection state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // Check if there is no data or if the data list is empty
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("No products available"));
            }

            // Get the list of products from the snapshot
            final products = snapshot.data!.docs;

            return SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, i) {
                  // Get product data as a map
                  final product = products[i].data() as Map<String, dynamic>;

                  // Safely access fields (make sure these match your Firestore document structure)
                  final imageUrl = product['imageUrl']; // Accessing image URL
                  final title = product['title'] ??
                      'No Title'; // Accessing title with a fallback

                  final price = product['price']?.toString() ??
                      '0'; // Accessing price with a fallback

                  return Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: imageUrl != null
                                ? Image.network(imageUrl,
                                    height: 110,
                                    width: MediaQuery.of(context).size.width)
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 70,
                                    color: Colors.grey, // Placeholder for image
                                  ),
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),

                        const SizedBox(
                            height: 5), // Added SizedBox to replace Spacer
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\Rs. $price",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
