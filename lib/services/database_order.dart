import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseOrder {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('Orders');

  // Method to fetch orders
  Stream<QuerySnapshot> viewOrders() {
    return ordersCollection.snapshots(); // No need for await here
  }

  // Method to create a new user document
  Future<void> createUser(
      String uid, String name, String email, String mobile, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name, // Field: name
      'email': email, // Field: email
      'mobile': mobile, // Field: mobile
      'role': role, // Field: role (e.g., 'user' or 'admin')
      'createdAt': FieldValue.serverTimestamp(), // Optional: Save creation time
    });
  }
}
