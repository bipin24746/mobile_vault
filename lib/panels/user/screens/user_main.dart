import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/user/screens/containers/categories.dart';
import 'package:mobile_vault/panels/user/screens/containers/searchbar.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Mobile Vault",
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart, size: 35),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Searchbar(),
          ),
          Categories(),
        ],
      ),
    );
  }
}
