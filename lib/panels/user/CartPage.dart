import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/addbuyproducts.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductDescription.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductImage.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/ProductTitlePrice.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/containers/details.dart';

class CartPage extends StatefulWidget {
  final String userId;

  CartPage({required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> selectedItems = [];

  void toggleSelection(String docId) {
    setState(() {
      if (selectedItems.contains(docId)) {
        selectedItems.remove(docId);
      } else {
        selectedItems.add(docId);
      }
    });
  }

  Future<void> deleteSelectedItems() async {
    for (String docId in selectedItems) {
      await FirebaseFirestore.instance.collection('cart').doc(docId).delete();
    }
    setState(() {
      selectedItems.clear();
    });
  }

  void _openProductDetails(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          product:
              product, // Pass the entire product data including description
          userId: widget.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (selectedItems.isNotEmpty) {
                deleteSelectedItems();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Your cart is empty"));
          }

          final cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index].data() as Map<String, dynamic>;
              final docId = cartItems[index].id;

              return ListTile(
                leading: Image.network(
                  item['imageUrl'] ?? '',
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.error),
                ),
                title: Text(item['title'] ?? 'No Title'),
                subtitle: Text("Rs. ${item['price'] ?? '0'}"),
                trailing: Checkbox(
                  value: selectedItems.contains(docId),
                  onChanged: (bool? value) {
                    toggleSelection(docId);
                  },
                ),
                onTap: () {
                  _openProductDetails(
                      item); // Pass item data to product details
                },
              );
            },
          );
        },
      ),
    );
  }
}
