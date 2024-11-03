import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_vault/panels/admin/screens/ManageProducts/deleteProducts.dart';
import 'package:mobile_vault/panels/admin/screens/ManageProducts/updateProduct.dart';
import 'package:mobile_vault/services/database_product.dart';

class ReadProducts extends StatefulWidget {
  const ReadProducts({super.key});

  @override
  State<ReadProducts> createState() => _ReadProductsState();
}

class _ReadProductsState extends State<ReadProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("E-Vault", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseProduct().viewProducts('', searchQuery: ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products available."));
          }

          List<DocumentSnapshot> data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> product =
                  data[index].data() as Map<String, dynamic>;

              // Fetching values with null checks
              String title = product['title'] ?? 'No Title';
              String description = product['description'] ?? 'No Description';
              String price = product['price']?.toString() ?? '0';
              String brand = product['brand'] ?? 'No Brand';
              String accessory = product['accessory'] ?? 'No Accessory';
              List<dynamic> tags = product['tags'] ?? [];
              String imageUrl = product['imageUrl'] ?? '';

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description: $description",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("Price: $price"),
                        Text("Brand: $brand"),
                        if (product['category'] == 'Accessories')
                          Text("Accessory: $accessory"),
                        Text("Tags: ${tags.join(', ')}"),
                      ],
                    ),
                  ),
                  leading: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              width: 50,
                              height: 50,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                              child:
                                  const Icon(Icons.image, color: Colors.white),
                            );
                          },
                        )
                      : Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey,
                          child: const Icon(Icons.image, color: Colors.white),
                        ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProduct(
                                docId: data[index].id,
                                initialTitle: title,
                                initialDescription: description,
                                initialPrice: price,
                                initialBrand: brand,
                                initialAccessory: accessory,
                                initialTags: List<String>.from(tags),
                                initialImageUrl: imageUrl,
                                initialCategory: product['category'],
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete Product"),
                                content: const Text(
                                    "Are you sure you want to delete this product?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await DatabaseProduct()
                                          .deleteProduct(data[index].id);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
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
