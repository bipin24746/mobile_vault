import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_vault/services/database_product.dart';

class UpdateProduct extends StatefulWidget {
  final String docId;
  final String initialTitle;
  final String initialDescription;
  final String initialPrice;
  final String initialBrands;
  final String initialCategories;
  final File? selectedImage;

  UpdateProduct({
    required this.docId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialPrice,
    required this.initialCategories,
    required this.initialBrands,
    this.selectedImage,
    super.key,
  });

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  // Text controllers
  final TextEditingController productTitle = TextEditingController();
  final TextEditingController productDescription = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
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
  @override
  void initState() {
    super.initState();

    // Initialize text fields with initial values
    productTitle.text = widget.initialTitle;
    productDescription.text = widget.initialDescription;
    productPrice.text = widget.initialPrice;

    // Check and set initial dropdown values or set defaults
    selectedBrand = brands.contains(widget.initialBrands)
        ? widget.initialBrands
        : brands.first;
    selectedCategory = categories.contains(widget.initialCategories)
        ? widget.initialCategories
        : categories.first;

    selectedImage = widget.selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    await DatabaseProduct().updateProduct(
                      widget.docId,
                      productTitle.text,
                      productDescription.text,
                      productPrice.text,
                      selectedImage,
                      selectedBrand!,
                      selectedCategory!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Product Updated Successfully!")),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Update Failed: $e")),
                    );
                  }
                },
                child: Text("Update", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
