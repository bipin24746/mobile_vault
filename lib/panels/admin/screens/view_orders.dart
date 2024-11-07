import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrderPage extends StatefulWidget {
  final String userId;

  const ViewOrderPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ViewOrderPageState createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  bool showPending = true; // Toggle between Pending and Confirmed

  Future<void> confirmOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Orders')
          .doc(orderId)
          .update({'status': 'Confirmed'});

      print("Order confirmed successfully.");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order confirmed!")),
        );
      }
    } catch (e) {
      print("Failed to confirm order: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        actions: [
          // Toggle between Pending and Confirmed orders
          TextButton(
            onPressed: () {
              setState(() {
                showPending = true;
              });
            },
            child: Text(
              "Pending Orders",
              style: TextStyle(
                color: showPending ? Colors.blue : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                showPending = false;
              });
            },
            child: Text(
              "Confirmed Orders",
              style: TextStyle(
                color: !showPending ? Colors.blue : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('status', isEqualTo: showPending ? 'Pending' : 'Confirmed')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found."));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderData = order.data() as Map<String, dynamic>;
              final products = orderData['products'] as List<dynamic>;

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
                      Text("Name: ${orderData['userName']}"),
                      Text("Address: ${orderData['userAddress']}"),
                      Text("Mobile: ${orderData['userMobile']}"),
                      Text("Email: ${orderData['userEmail']}"),
                      const SizedBox(height: 10),
                      Text("Order Date: ${orderData['orderDate']?.toDate()}"),
                      const SizedBox(height: 10),
                      const Text("Products:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...products.map((product) {
                        return ListTile(
                          leading: Image.network(product['imageUrl']),
                          title: Text(product['title']),
                          subtitle: Text("Price: Rs. ${product['price']}"),
                          trailing: Text("Quantity: ${product['quantity']}"),
                        );
                      }).toList(),
                      if (showPending) ...[
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            await confirmOrder(order.id);
                          },
                          child: const Text("Confirm Order"),
                        ),
                      ],
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
