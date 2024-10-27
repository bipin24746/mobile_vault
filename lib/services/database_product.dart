import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseProduct {
  final CollectionReference evaultProductDetails =
      FirebaseFirestore.instance.collection('Evault Products');

  // Upload image to Firebase Storage
  Future<String?> uploadImageToFirebase(File image) async {
    try {
      String filePath =
          'product_images/${DateTime.now().millisecondsSinceEpoch}';
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(filePath).putFile(image);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  // Create
  Future<void> addProduct(
    String title,
    String description,
    String price,
    File? image,
    String brands,
    String categories,
  ) async {
    String? imageUrl;

    if (image != null) {
      imageUrl = await uploadImageToFirebase(image);
    }

    await evaultProductDetails.add({
      "productTitle": title,
      "productDescription": description,
      "productPrice": price,
      "imageUrl": imageUrl,
      "brands": brands,
      "categories": categories,
    });
  }

  // Read
  Stream<QuerySnapshot> viewProducts() {
    return evaultProductDetails.snapshots();
  }

  // Update
  Future<void> updateProduct(
    String id,
    String title,
    String description,
    String price,
    File? image,
    String brands,
    String categories,
  ) async {
    String? imageUrl;

    // Check if a new image is provided
    if (image != null) {
      imageUrl = await uploadImageToFirebase(image);
    } else {
      // Retrieve existing imageUrl if image is null
      DocumentSnapshot snapshot = await evaultProductDetails.doc(id).get();
      imageUrl = snapshot['imageUrl'];
    }

    // Update document
    await evaultProductDetails.doc(id).update({
      "productTitle": title,
      "productDescription": description,
      "productPrice": price,
      "imageUrl": imageUrl,
      "brands": brands,
      "categories": categories,
    });
  }

  // Delete
  Future<void> deleteProduct(String id) {
    return evaultProductDetails.doc(id).delete();
  }
}
