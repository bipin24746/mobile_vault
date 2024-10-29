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
  final List<String> initialTags;
  final String? initialImageUrl; // Added this line for initial image URL

  UpdateProduct({
    required this.docId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialPrice,
    required this.initialCategories,
    required this.initialBrands,
    required this.initialTags,
    this.initialImageUrl, // Initialize the initial image URL
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
  final TextEditingController productTags = TextEditingController();

  File? selectedImage;

  // Dropdown variables
  String? selectedBrand;
  String? selectedCategory;

  // Dropdown items
  final List<String> brands = ['Samsung', 'Apple', 'OnePlus'];
  final List<String> categories = ['Mobile', 'Tablet', 'Laptop'];

  @override
  void initState() {
    super.initState();

    // Initialize text fields with initial values
    productTitle.text = widget.initialTitle;
    productDescription.text = widget.initialDescription;
    productPrice.text = widget.initialPrice;
    productTags.text = widget.initialTags.join(', '); // Join tags for display

    // Set initial dropdown values, check for valid values
    selectedBrand =
        brands.contains(widget.initialBrands) ? widget.initialBrands : null;
    selectedCategory = categories.contains(widget.initialCategories)
        ? widget.initialCategories
        : null;

    // Initialize the selected image if available
    selectedImage = null; // Start with no image selected
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        selectedImage = File(imageFile.path);
      });
    }
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
              SizedBox(height: 10),

              // Tags Text Field
              TextFormField(
                controller: productTags,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  hintText: "Enter Product Tags (comma separated)",
                ),
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
                onPressed: pickImage,
                child: Text("Pick an Image"),
              ),
              // Display image from URL if no new image is selected
              if (selectedImage == null &&
                  widget.initialImageUrl != null &&
                  widget.initialImageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(widget.initialImageUrl!,
                      height: 100, width: 100, fit: BoxFit.cover),
                )
              else if (selectedImage != null) // Show the picked image
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(selectedImage!, height: 100, width: 100),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  try {
                    // Call the updateProduct method with the necessary parameters
                    await DatabaseProduct().updateProduct(
                      widget.docId,
                      productTitle.text,
                      productDescription.text,
                      productPrice.text,
                      selectedImage, // Pass the selected image (null if no new image)
                      selectedBrand!, // Ensure this is not null
                      selectedCategory!, // Ensure this is not null
                      productTags.text
                          .split(',')
                          .map((tag) => tag.trim())
                          .toList(), // Convert tags to a list
                    );

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Product Updated Successfully!")),
                    );

                    // Navigate back to the previous screen
                    Navigator.pop(context);
                  } catch (e) {
                    // Show an error message if the update fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Update Failed: ${e.toString()}")),
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
