import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_vault/Login%20Details/loginpage.dart';
import 'package:mobile_vault/panels/admin/screens/ManageProducts/manage_products.dart';
import 'package:mobile_vault/panels/admin/screens/homepage_container/setting.dart';
import 'package:mobile_vault/panels/admin/screens/homepage_container/userInfo.dart';
import 'package:mobile_vault/panels/admin/screens/homepage_container/viewOrder.dart';
import 'package:mobile_vault/panels/admin/screens/settings.dart';
import 'package:mobile_vault/panels/admin/screens/user_info.dart';
import 'package:mobile_vault/panels/admin/screens/view_orders.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Admin Panel",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Admin"),
              accountEmail:
                  const Text("admin@example.com"), // Replace with actual email
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 24.0, color: Colors.blue),
                ),
              ),
            ),
            ListTile(
              title: const Text("Manage Products"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminManageProducts()),
                );
              },
            ),
            ListTile(
              title: const Text("View Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewOrderPage(userId: userId)),
                );
              },
            ),
            ListTile(
              title: const Text("User Info"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => userInfo()),
                );
              },
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                );
              },
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: () {
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: const Text(
                "Welcome to Admin Page",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildAdminButton(Icons.shopping_bag, "Manage Products", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminManageProducts()),
                  );
                }),
                _buildAdminButton(Icons.receipt_long, "View Orders", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOrderPage(userId: userId)),
                  );
                }),
                _buildAdminButton(Icons.people, "User Info", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => userInfo()),
                  );
                }),
                _buildAdminButton(Icons.settings, "Settings", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Setting()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminButton(IconData icon, String label, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Sign out
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Loginpage()),
                ); // Navigate to login page
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
