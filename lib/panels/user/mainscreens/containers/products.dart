import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_vault/panels/user/productDetailsScreens/lib/panels/user/productDetailsScreens/product_detail_page.dart';

import 'package:mobile_vault/services/database_product.dart';

class ProductsPage extends StatefulWidget {
  final String category;
  final String searchQuery;

  ProductsPage({required this.category, required this.searchQuery});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedCategory = "All";
  String selectedBrand = "All";
  String selectedAlphabetSort = "A-Z"; // Default alphabetical sort
  String selectedPriceSort = "None"; // Default price sort (None)

  List<String> categories = [
    "All",
    'SmartPhones',
    'Chargers',
    'Headsets',
    'Cases and Covers',
    'Screen protectors',
    'Power Bank',
  ];

  List<String> brands = [
    "All",
    'Apple',
    'Samsung',
    'Xiaomi',
    'Oppo',
    'Vivo',
    'Realme',
    'Huawei',
  ];

  List<String> alphabetSortOptions = [
    "A-Z",
    "Z-A",
  ];

  List<String> priceSortOptions = [
    "None",
    "Low to High",
    "High to Low",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          // Brand Filter Buttons
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: brands.map((brand) {
                  final isSelected = selectedBrand == brand;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedBrand = brand;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.blueAccent : Colors.white,
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                      ),
                      child: Text(brand),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Category Filter Buttons
          Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.blue : Colors.white,
                        foregroundColor:
                            isSelected ? Colors.white : Colors.black,
                      ),
                      child: Text(category),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Sort Options: Alphabet and Price side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Alphabetical Sort Dropdown
              DropdownButton<String>(
                value: selectedAlphabetSort,
                items: alphabetSortOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text("Sort: $option"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAlphabetSort = value!;
                  });
                },
              ),
              // Price Sort Dropdown
              DropdownButton<String>(
                value: selectedPriceSort,
                items: priceSortOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text("Price: $option"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPriceSort = value!;
                  });
                },
              ),
            ],
          ),

          // Product List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: DatabaseProduct().viewProducts(
                category: selectedCategory,
                brand: selectedBrand,
                searchQuery: '',
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No products found in this category/brand",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // Sorting the products based on selected options
                List<DocumentSnapshot> products = snapshot.data!.docs;

                // Apply Alphabetical sorting
                if (selectedAlphabetSort == "A-Z") {
                  products.sort((a, b) => a['title'].compareTo(b['title']));
                } else if (selectedAlphabetSort == "Z-A") {
                  products.sort((a, b) => b['title'].compareTo(a['title']));
                }

                // Apply Price sorting if selected
               if (selectedPriceSort == "Low to High") {
  products.sort((a, b) {
    final priceA = double.tryParse(a['price'].toString()) ?? 0;
    final priceB = double.tryParse(b['price'].toString()) ?? 0;
    return priceA.compareTo(priceB);
  });
} else if (selectedPriceSort == "High to Low") {
  products.sort((a, b) {
    final priceA = double.tryParse(a['price'].toString()) ?? 0;
    final priceB = double.tryParse(b['price'].toString()) ?? 0;
    return priceB.compareTo(priceA);
  });
}

                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final product =
                        products[index].data() as Map<String, dynamic>;
                    final imageUrl = product['imageUrl'];
                    final title = product['title'] ?? 'No Title';
                    final price = product['price']?.toString() ?? '0';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              product: product,
                              userId: '',
                            ),
                          ),
                        );
                      },
                      child: IntrinsicHeight(
                        child: Card(
                          color: Colors.white,
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: imageUrl != null
                                    ? Image.network(
                                        imageUrl,
                                        height: 150,
                                        width: double.infinity,
                                        fit: BoxFit.contain,
                                      )
                                    : Container(
                                        height: 150,
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: Center(child: Text("No Image")),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Price: Rs. $price",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
