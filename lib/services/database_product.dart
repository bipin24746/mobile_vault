import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseProduct {
  final CollectionReference evaultProductDetails =
      FirebaseFirestore.instance.collection('Evault Products');

  // Function to upload an image to Firebase Storage and get the URL
  Future<String?> uploadImageToFirebase(File image) async {
    try {
      String filePath =
          'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (!await image.exists()) {
        print("Image file does not exist");
        return null;
      }

      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref(filePath).putFile(image);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  // Function to add a product to Firestore
  Future<void> addProduct(
    String title,
    String description,
    String price,
    File image,
    String brand,
    String category,
    String? accessory,
    List<String> tags,
  ) async {
    try {
      String? imageUrl;

      // Upload image if available
      if (image != null) {
        imageUrl = await uploadImageToFirebase(image);
      }

      // Prepare the product data
      Map<String, dynamic> productData = {
        'title': title,
        'description': description,
        'price': price,
        'brand': brand,
        'category': category,
        'tags': tags,
        if (category == 'Accessories') 'accessory': accessory,
        if (imageUrl != null) 'imageUrl': imageUrl,
      };

      // Add product to Firestore collection
      await evaultProductDetails.add(productData);
      print("Product added successfully: $title");
    } catch (e) {
      print('Error adding product: $e');
      throw e;
    }
  }

  // Function to update an existing product in Firestore
  Future<void> updateProduct(
      String id,
      String title,
      String description,
      String price,
      File? image,
      String brand,
      String category,
      String? accessory,
      List<String> tags) async {
    try {
      String? imageUrl;

      // Upload image if available
      if (image != null) {
        imageUrl = await uploadImageToFirebase(image);
      }

      await evaultProductDetails.doc(id).update({
        'title': title,
        'description': description,
        'price': price,
        'brand': brand,
        'category': category,
        if (category == 'Accessories') 'accessory': accessory,
        'tags': tags,
        if (imageUrl != null) 'imageUrl': imageUrl,
      });
      print("Product updated successfully: $title");
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  // Function to delete a product from Firestore
  Future<void> deleteProduct(String id) async {
    try {
      await evaultProductDetails.doc(id).delete();
      print("Product deleted successfully.");
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Stream<QuerySnapshot> viewProducts({String? category, String? brand}) {
    Query query = evaultProductDetails;

    // Apply filters conditionally for category and brand
    if (category != null && category != 'All' && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }
    if (brand != null && brand != 'All' && brand.isNotEmpty) {
      query = query.where('brand', isEqualTo: brand);
    }

    return query.snapshots();
  }

  // Function to get product details by ID (for updating)
  Future<DocumentSnapshot> getProductById(String id) async {
    try {
      DocumentSnapshot snapshot = await evaultProductDetails.doc(id).get();
      return snapshot;
    } catch (e) {
      print('Error getting product by ID: $e');
      throw e;
    }
  }
}
