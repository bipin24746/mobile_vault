import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserOrderPage extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    // Displaying the userId to confirm it's being retrieved correctly
    print("User ID: $userId");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                  "No orders found for User ID: $userId"), // Shows userId for debugging
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderData = order.data() as Map<String, dynamic>;
              final products = orderData['products'] as List<dynamic>;
              final status = orderData['status'] == 'Confirmed'
                  ? "Your order has been confirmed"
                  : "Pending";

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order ID: ${order.id}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("Status: $status"),
                      const SizedBox(height: 10),
                      Text("Products:",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      ...products.map((product) {
                        return ListTile(
                          leading: Image.network(product['imageUrl']),
                          title: Text(product['title']),
                          subtitle: Text("Price: Rs. ${product['price']}"),
                          trailing: Text("Quantity: ${product['quantity']}"),
                        );
                      }).toList(),
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
