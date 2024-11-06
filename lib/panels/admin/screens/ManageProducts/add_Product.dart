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

  String? selectedCategory; // To hold the selected category
  String? selectedBrand; // To hold the selected brand
  String? selectedAccessories; // To hold the selected accessories
  List<String> categories = ['SmartPhones', 'Accessories']; // Categories
  List<String> brands = [
    'Apple',
    'Samsung',
    'Xiaomi',
    'Oppo',
    'Vivo',
    'Realme',
    'Huawei',
  ]; // Example brand list
  List<String> accessories = [
    'Chargers',
    'Headsets',
    'Cases and Covers',
    'Screen protectors',
    'Power Bank'
  ]; // Example accessories list

  XFile? selectedImage; // To hold the selected image file

  // Function to pick an image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    selectedImage = await picker.pickImage(source: ImageSource.gallery);

    if (mounted) {
      setState(() {}); // Update the UI after image selection
    }
  }

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
                      borderRadius: BorderRadius.circular(25)),
                  hintText: "Enter Product Title",
                ),
              ),
              const SizedBox(height: 10),
              Text("Product Description"),
              TextFormField(
                controller: productDescription,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  hintText: "Enter Product Description",
                ),
              ),
              const SizedBox(height: 10),
              Text("Product Price"),
              TextFormField(
                controller: productPrice,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  hintText: "Enter Product Price",
                ),
                keyboardType: TextInputType.number,
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
                    selectedAccessories =
                        null; // Reset accessories when category changes
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
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
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              const SizedBox(height: 10),
              if (selectedCategory ==
                  'Accessories') // Show this only if Accessories is selected
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Accessories"),
                    DropdownButtonFormField<String>(
                      value: selectedAccessories,
                      items: accessories.map((accessory) {
                        return DropdownMenuItem<String>(
                          value: accessory,
                          child: Text(accessory),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAccessories = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              Text("Product Tags (comma separated)"),
              TextFormField(
                controller: productTags,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
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
                  // Validate input fields
                  if (productTitle.text.isEmpty ||
                      productDescription.text.isEmpty ||
                      productPrice.text.isEmpty ||
                      selectedBrand == null ||
                      (selectedCategory == 'Accessories' &&
                          selectedAccessories ==
                              null) || // Validate for accessories
                      selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill all fields!")),
                    );
                    return; // Exit the function if validation fails
                  }

                  List<String> tags = productTags.text
                      .split(',')
                      .map((tag) => tag.trim())
                      .where((tag) => tag.isNotEmpty) // Filter out empty tags
                      .toList();

                  try {
                    print("Adding product: ${productTitle.text}");
                    await DatabaseProduct().addProduct(
                      productTitle.text,
                      productDescription.text,
                      productPrice.text,
                      File(selectedImage!.path), // Convert XFile to File here
                      selectedBrand!,
                      selectedCategory == 'Accessories'
                          ? selectedAccessories!
                          : 'SmartPhones', // Add selected category here
                      null, // Set to null if not applicable
                      tags,
                    );
                    print("Product added successfully");
                    if (mounted) {
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
                        selectedCategory = null; // Reset category
                        selectedAccessories = null; // Reset accessories
                      });
                      Navigator.pop(context); // Navigate back after submission
                    }
                  } catch (e) {
                    print("Failed to add product: $e");
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to add product: $e")),
                      );
                    }
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
