import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome to the Admin Panel!",
                style: TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                // Add functionality for admin actions
              },
              child: const Text("Manage Products"),
            ),
            // Add more admin functionalities as needed
          ],
        ),
      ),
    );
  }
}
