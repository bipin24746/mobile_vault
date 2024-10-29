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
            _buildCategoryItem("Tablets", 'lib/assets/images/tablet.jpg'),
            _buildCategoryItem(
                "Accessories", 'lib/assets/images/smartphones.jpg'),
            _buildCategoryItem("Laptops", 'lib/assets/images/tablet.jpg'),
            _buildCategoryItem("Watches", 'lib/assets/images/smartphones.jpg'),
            _buildCategoryItem("Headphones", 'lib/assets/images/tablet.jpg'),
            // Add more items as needed with unique image paths
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10), // Space between items
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 5), // Space between image and text
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
