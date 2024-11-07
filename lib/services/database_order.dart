import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseOrder {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('Orders');

  Future<void> placeOrder(
    String userId,
    String userName,
    String userAddress,
    String userMobile,
    String userEmail,
    List<Map<String, dynamic>> products,
  ) async {
    if (userId.isEmpty) {
      print("Error: User is not logged in.");
      return;
    }

    try {
      await ordersCollection.add({
        'userId': userId,
        'userName': userName,
        'userAddress': userAddress,
        'userMobile': userMobile,
        'userEmail': userEmail,
        'products': products,
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'Pending',
      });

      print("Order placed successfully.");
    } catch (e) {
      print("Failed to place order: $e");
    }
  }
}
