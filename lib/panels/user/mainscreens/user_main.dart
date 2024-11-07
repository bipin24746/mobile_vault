import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:mobile_vault/Login%20Details/loginpage.dart';
import 'package:mobile_vault/panels/user/mainscreens/containers/product_search_page.dart';
import 'package:mobile_vault/panels/user/mainscreens/containers/products.dart';
import 'package:mobile_vault/panels/user/mainscreens/containers/searchbar.dart';
import 'package:mobile_vault/panels/user/user_order_page.dart';

class UserPage extends StatelessWidget {
  final String userId;

  UserPage({required this.userId});

  void onSearch(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSearchPage(
          searchQuery: query,
          category: '',
          brand: '',
        ),
      ),
    );
  }

  void onLogout(BuildContext context) async {
    // Show the confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                // Close the dialog
                Navigator.of(context).pop();
                // Sign out the user from Firebase
                await FirebaseAuth.instance.signOut();
                // Redirect to the login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Loginpage()), // Ensure you have a LoginScreen
                  (route) =>
                      false, // Removes all routes and goes directly to LoginScreen
                );
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserOrderPage()),
            );
          },
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
          tooltip: "See Orders",
        ),
        title: Text(
          "Mobile Vault",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () => onLogout(context),
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Searchbar(
              onSearch: (query) => onSearch(context, query),
            ),
          ),
        ),
      ),
      body: ProductsPage(
        searchQuery: '',
        category: '',
      ),
    );
  }
}
