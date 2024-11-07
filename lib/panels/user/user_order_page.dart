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
              child: Text("No orders found for User ID: $userId"),
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
                      const SizedBox(height: 10),
                      if (status == "Pending")
                        ElevatedButton(
                          onPressed: () {
                            _showCancelDialog(context, order.id);
                          },
                          child: const Text("Cancel Order"),
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

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Order"),
          content: const Text("Are you sure you want to cancel this order?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await _cancelOrder(orderId);
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(orderId)
          .delete();
      print("Order canceled successfully.");

      // Optionally show a snackbar or other UI feedback
    } catch (e) {
      print("Failed to cancel order: $e");
    }
  }
}
