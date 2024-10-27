import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_vault/services/database_product.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProduct extends StatelessWidget {
  final String docId;
  final String initialTitle;
  final String initialDescription;
  final String initialPrice;

  UpdateProduct({
    required this.docId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialPrice,
    super.key,
  });

  final TextEditingController productTitle = TextEditingController();
  final TextEditingController productDescription = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    // Set initial values for controllers
    productTitle.text = initialTitle;
    productDescription.text = initialDescription;
    productPrice.text = initialPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextFormField(
              controller: productTitle,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: "Enter Product Title",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: productDescription,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: "Enter Product Description",
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: productPrice,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: "Enter Product Price",
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? imageFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (imageFile != null) {
                  selectedImage = File(imageFile.path);
                }
              },
              child: Text("Pick an Image"),
            ),
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.file(selectedImage!, height: 100, width: 100),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                DatabaseProduct()
                    .updateProduct(
                  docId,
                  productTitle.text,
                  productDescription.text,
                  productPrice.text,
                  selectedImage,
                )
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Product Updated Successfully!")),
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Update Failed: $error")),
                  );
                });
              },
              child: Text("Update", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
