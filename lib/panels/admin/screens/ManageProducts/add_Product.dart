import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File class
import 'package:mobile_vault/services/database_product.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  TextEditingController productTitle = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productTags = TextEditingController();

  String? selectedBrand; // To hold the selected brand
  String? selectedCategory; // To hold the selected category
  List<String> brands = ['Samsung', 'Apple', 'OnePlus']; // Example brand list
  List<String> categories = [
    'Mobile',
    'Tablet',
    'Laptop'
  ]; // Example category list

  XFile? selectedImage; // To hold the selected image file

  // Function to pick an image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    selectedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {}); // Update the UI after image selection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Add Products",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text("Product Title"),
              TextFormField(
                controller: productTitle,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: "Enter Product Title",
                ),
              ),
              const SizedBox(height: 10),
              Text("Product Description"),
              TextFormField(
                controller: productDescription,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: "Enter Product Description",
                ),
              ),
              const SizedBox(height: 10),
              Text("Product Price"),
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
              Text("Select Brand"),
              DropdownButtonFormField<String>(
                value: selectedBrand,
                items: brands.map((brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBrand = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("Select Category"),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text("Product Tags (comma separated)"),
              TextFormField(
                controller: productTags,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: "Enter Product Tags",
                ),
              ),
              const SizedBox(height: 10),
              Text("Select Product Image"),
              ElevatedButton(
                onPressed: pickImage,
                child: Text(
                    selectedImage == null ? "Choose Image" : "Change Image"),
              ),
              if (selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.file(
                    File(selectedImage!.path), // Convert XFile to File
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  List<String> tags = productTags.text
                      .split(',')
                      .map((tag) => tag.trim())
                      .toList();
                  try {
                    await DatabaseProduct().addProduct(
                      productTitle.text,
                      productDescription.text,
                      productPrice.text,
                      File(selectedImage!.path), // Convert XFile to File here
                      selectedBrand!,
                      selectedCategory!,
                      tags,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Product added successfully!")),
                    );
                    // Clear fields after submission
                    productTitle.clear();
                    productDescription.clear();
                    productPrice.clear();
                    productTags.clear();
                    setState(() {
                      selectedImage = null;
                      selectedBrand = null;
                      selectedCategory = null;
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to add product: $e")),
                    );
                  }
                },
                child: Text("Submit", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
