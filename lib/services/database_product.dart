import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseProduct {
  final CollectionReference evaultProductDetails =
      FirebaseFirestore.instance.collection('Evault Products');

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

  Future<void> deleteProduct(String id) async {
    await evaultProductDetails.doc(id).delete();
  }
}
