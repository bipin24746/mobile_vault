import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_vault/services/database_product.dart';

class UpdateProduct extends StatefulWidget {
  final String docId;
  final String initialTitle;
  final String initialDescription;
  final String initialPrice;
  final String initialBrand;
  final String initialAccessory;
  final List<String> initialTags;
  final String? initialImageUrl;
  final String? initialCategory; // Keep this for your reference

  UpdateProduct({
    required this.docId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialPrice,
    required this.initialAccessory,
    required this.initialBrand,
    required this.initialTags,
    this.initialImageUrl,
    this.initialCategory, // Keep this for your reference
    super.key,
  });

  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final TextEditingController productTitle = TextEditingController();
  final TextEditingController productDescription = TextEditingController();
  final TextEditingController productPrice = TextEditingController();
  final TextEditingController productTags = TextEditingController();

  File? selectedImage;

  final String selectedCategory = 'Smartphones'; // Set static category
  String? selectedBrand;
  String? selectedAccessory;

  final List<String> brands = ['Samsung', 'Apple', 'OnePlus'];
  final List<String> accessories = ['Charger', 'Earphones', 'Case'];

  @override
  @override
  void initState() {
    super.initState();
    productTitle.text = widget.initialTitle;
    productDescription.text = widget.initialDescription;
    productPrice.text = widget.initialPrice;
    productTags.text = widget.initialTags.join(', ');

    // Initialize selectedBrand safely, either from widget or default to the first brand
    selectedBrand = widget.initialBrand != null &&
            brands.contains(widget.initialBrand)
        ? widget.initialBrand
        : brands.isNotEmpty
            ? brands
                .first // Default to the first brand in the list if initialBrand is invalid
            : null;

    // Initialize selectedAccessory safely
    if (widget.initialAccessory != null &&
        accessories.contains(widget.initialAccessory)) {
      selectedAccessory = widget.initialAccessory; // Valid accessory
    } else {
      selectedAccessory = null; // Reset if invalid or no accessory
    }
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

              // Static Category Display
              Text("Category: $selectedCategory",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

              // Accessories Dropdown, shown only if "Accessories" is selected
              if (selectedCategory == 'Accessories')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Accessory"),
                    DropdownButtonFormField<String>(
                      value: selectedAccessory,
                      items: [
                        DropdownMenuItem<String>(
                          value: null, // Allow no selection
                          child: Text("Select Accessory"),
                        ),
                        ...accessories.map((String accessory) {
                          return DropdownMenuItem(
                            value: accessory,
                            child: Text(accessory),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedAccessory =
                              value; // Allow it to be null if needed
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Pick an Image"),
              ),
              if (selectedImage == null &&
                  widget.initialImageUrl != null &&
                  widget.initialImageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.network(
                    widget.initialImageUrl!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                )
              else if (selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.file(
                    selectedImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  try {
                    List<String> tags = productTags.text.isNotEmpty
                        ? productTags.text
                            .split(',')
                            .map((tag) => tag.trim())
                            .toList()
                        : [];

                    await DatabaseProduct().updateProduct(
                      widget.docId,
                      productTitle.text,
                      productDescription.text,
                      productPrice.text,
                      selectedImage,
                      selectedBrand ?? '',
                      selectedAccessory ?? '',
                      null,
                      tags,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Product Updated Successfully!")),
                    );

                    Navigator.pop(context);
                  } catch (e) {
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
