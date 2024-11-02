import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseOrder {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('Orders');

  Future<void> placeOrder(
      String userId,
      String userName,
      String userAddress,
      String userMobile,
      String userEmail,
      List<Map<String, dynamic>> products) async {
    try {
      await ordersCollection.add({
        'userName': userName,
        'userAddress': userAddress,
        'userMobile': userMobile,
        'userEmail': userEmail,
        'products': products,
        'orderDate':
            FieldValue.serverTimestamp(), // Automatically set the order date
        'status': 'Pending' // Initial status
      });

      print("Order placed successfully.");
    } catch (e) {
      print("Failed to place order: $e");
    }
  }
}
