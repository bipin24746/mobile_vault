import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        title: Text("E-Vault", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseProduct().viewProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products available."));
          }

          List<DocumentSnapshot> data = snapshot.data!.docs;
          print(
              "Fetched ${data.length} products from Firestore"); // Debug print

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              DocumentSnapshot eachDoc = data[index];
              Map<String, dynamic> map = eachDoc.data() as Map<String, dynamic>;

              return _buildProductCard(map, eachDoc.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> map, String docId) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title: ${map['productTitle'] ?? 'N/A'}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Description: ${map['productDescription'] ?? 'N/A'}"),
                SizedBox(height: 4),
                Text("Price: \Rs.${map['productPrice'] ?? 'N/A'}"),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to UpdateProduct and pass current values
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProduct(
                    docId: docId,
                    initialTitle: map['productTitle'] ?? '',
                    initialDescription: map['productDescription'] ?? '',
                    initialPrice: map['productPrice'] ?? '',
                    initialCategories: '',
                    initialBrands: '',
                  ),
                ),
              );
            },
          ),
          DeleteProducts(productId: docId), // Delete button
        ],
      ),
    );
  }
}
