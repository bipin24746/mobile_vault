import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/user/mainscreens/containers/products.dart';

class CategoriesPage extends StatelessWidget {
  final List<String> categories = [
    'Tablet',
    'Mobile',
    'Home & Kitchen',
    'Beauty',
    'Sports',
    // Add more categories as needed
  ];

  void onCategorySelected(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(
          category: category,
          searchQuery: '', // Pass an empty query for now
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCategorySelected(context, categories[index]),
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue, // Changed to red for consistency
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold, // Added bold for emphasis
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
