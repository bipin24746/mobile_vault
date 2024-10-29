import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0), // Padding around the whole container
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: Row(
          children: [
            _buildCategoryItem(
                "Smartphones", 'lib/assets/images/smartphones.jpg'),
            _buildCategoryItem("Tablet", 'lib/assets/images/tablet.jpg'),
            _buildCategoryItem(
                "Accessories", 'lib/assets/images/smartphones.jpg'),
            // Add more items as needed with unique image paths
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imagePath) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 8.0), // Space between items
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 12), // Space between image and text
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
