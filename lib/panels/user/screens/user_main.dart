import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Mobile Vault",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Column(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
              ],
            )
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(child: Text('Welcome, User!')),
    );
  }
}
