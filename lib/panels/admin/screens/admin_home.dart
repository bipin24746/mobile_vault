import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/admin/screens/homepage_container/manageProducts.dart';
import 'package:mobile_vault/panels/admin/screens/homepage_container/setting.dart';
import 'package:mobile_vault/panels/admin/screens/homepage_container/userInfo.dart';
import 'package:mobile_vault/panels/admin/screens/homepage_container/viewOrder.dart';

import 'package:mobile_vault/panels/admin/screens/user_info.dart';
import 'package:mobile_vault/panels/admin/screens/view_orders.dart';
import 'package:mobile_vault/panels/admin/screens/settings.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Admin Panel",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Admin Panel"),
            ),
            ListTile(
              title: Text("Manage Products"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageProductsAdmin()));
              },
            ),
            ListTile(
              title: Text("View Orders"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => viewOrderAdmin()));
              },
            ),
            ListTile(
              title: Text("User Info"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => userIfoAdmin()));
              },
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Setting()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Welcome to Admin Page",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the Row content
                  children: [
                    ManageProductsAdmin(),
                    viewOrderAdmin(),
                  ],
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the Row content
                  children: [userIfoAdmin(), settingAdmin()],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
