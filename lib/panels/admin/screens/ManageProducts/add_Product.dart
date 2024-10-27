import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_vault/services/database_product.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  // Text controllers
  TextEditingController productTitle = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  File? selectedImage;

  // Dropdown variables
  String? selectedBrand;
  String? selectedCategory;

  // Dropdown items
  final List<String> brands = [
    'Apple',
    'Samsung',
    'Huawei',
    'Xiaomi',
    'OnePlus'
  ];
  final List<String> categories = [
    'Smartphones',
    'Tablets',
    'Accessories',
    'Chargers'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text("Add Products", style: TextStyle(color: Colors.white)),
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
              const SizedBox(height: 20),

              // Brand Dropdown
              Text("Select Brand"),
              DropdownButtonFormField<String>(
                value: selectedBrand,
                items: brands.map((String brand) {
                  return DropdownMenuItem(
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

              // Category Dropdown
              Text("Select Category"),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem(
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
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? imageFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (imageFile != null) {
                    setState(() {
                      selectedImage = File(imageFile.path);
                    });
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
                onPressed: () async {
                  try {
                    await DatabaseProduct().addProduct(
                      productTitle.text,
                      productDescription.text,
                      productPrice.text,
                      selectedImage,
                      selectedBrand!,
                      selectedCategory!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Product added successfully!")),
                    );
                    // Clear fields after submission
                    productTitle.clear();
                    productDescription.clear();
                    productPrice.clear();
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
