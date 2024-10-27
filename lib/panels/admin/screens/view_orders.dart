import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mobile_vault/services/database_product.dart'; // Create this service file

class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("View Orders"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseProduct()
            .viewProducts(), // We will create this method in the service
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No orders available."));
          }

          List<DocumentSnapshot> data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              DocumentSnapshot eachDoc = data[index];
              Map<String, dynamic> map = eachDoc.data() as Map<String, dynamic>;

              return _buildOrderCard(map,
                  eachDoc.id); // Create this method to build the order card
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> map, String docId) {
    // Build your order card layout here
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order ID: $docId"),
          Text(
              "User: ${map['userId'] ?? 'N/A'}"), // Adjust according to your data structure
          Text("Total: \$${map['totalPrice'] ?? 'N/A'}"),
          // Add more order details as necessary
        ],
      ),
    );
  }
}
