import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseProduct {
  final CollectionReference evaultProductDetails =
      FirebaseFirestore.instance.collection('Evault Products');
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');

  // Function to upload an image to Firebase Storage and get the URL
  Future<String?> uploadImageToFirebase(File image) async {
    try {
      String filePath =
          'product_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Check if image exists before uploading
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

  // Function to add a new product to Firestore
  Future<void> addProduct(
      String title,
      String description,
      String price,
      File imageFile,
      String brand,
      String category,
      String? accessory,
      List<String> tags) async {
    try {
      String? imageUrl = await uploadImageToFirebase(imageFile);

      if (imageUrl == null) {
        throw Exception("Failed to upload image");
      }

      await evaultProductDetails.add({
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'brand': brand,
        'category': category,
        if (category == 'Accessories') 'accessory': accessory,
        'tags': tags,
      });

      print("Product added successfully: $title");
    } catch (e) {
      print('Error uploading product: $e');
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

      // Only upload image if provided
      if (image != null) {
        imageUrl = await uploadImageToFirebase(image);
      }

      // Update product details
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

  // Stream to view products with an optional search query
  Stream<QuerySnapshot> viewProducts({
    String? category,
    String? brand,
    String? searchQuery,
  }) {
    Query query = evaultProductDetails; // Use your defined collection reference

    // Apply filters based on the parameters
    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    if (brand != null && brand != 'All') {
      query = query.where('brand', isEqualTo: brand);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query
          .where('title', isGreaterThanOrEqualTo: searchQuery)
          .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff');
    }

    return query.snapshots(); // Return the stream of products
  }

  // Function to check if a product is already in the cart
  Future<bool> checkIfInCart(String userId, String productId) async {
    final cartSnapshot = await cartCollection
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .get();

    return cartSnapshot
        .docs.isNotEmpty; // Returns true if any documents are found
  }

  // Function to add a product to the cart collection
  Future<void> addToCart(String userId, String productId, String title,
      String price, String imageUrl, String description) async {
    try {
      // Check if the product is already in the cart
      bool isInCart = await checkIfInCart(userId, productId);

      if (isInCart) {
        print("Product is already in cart.");
        return; // Prevent adding the same product again
      }

      await cartCollection.add({
        'userId': userId,
        'productId': productId,
        'title': title,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': 1, // Default quantity is 1
        'description': description,
      });
      print("Product added to cart successfully.");
    } catch (e) {
      print("Failed to add product to cart: $e");
    }
  }

  // Stream to view cart items for a specific user
  Stream<QuerySnapshot> viewCartItems(String userId) {
    return cartCollection.where('userId', isEqualTo: userId).snapshots();
  }
}
