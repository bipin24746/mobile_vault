import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    List<String> tags,
  ) async {
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
    List<String> tags,
  ) async {
    try {
      String? imageUrl;

      if (image != null) {
        imageUrl = await uploadImageToFirebase(image);
      }

      await evaultProductDetails.doc(id).update({
        'title': title,
        'description': description,
        'price': price,
        'brand': brand,
        'category': category,
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
    await evaultProductDetails.doc(id).delete();
  }

  // Stream to view products by category, or all products if category is empty
  Stream<QuerySnapshot> viewProducts([String category = '']) {
    if (category.isEmpty) {
      return evaultProductDetails
          .snapshots(); // Get all products if no category is specified
    } else {
      return evaultProductDetails
          .where('category', isEqualTo: category)
          .snapshots(); // Filter by category
    }
  }

  // Function to check if a product is already in the cart
  Future<bool> checkIfInCart(String userId, String productId) async {
    final cartSnapshot = await cartCollection
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .get();

    return cartSnapshot.docs.isNotEmpty;
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
        'description': description
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
