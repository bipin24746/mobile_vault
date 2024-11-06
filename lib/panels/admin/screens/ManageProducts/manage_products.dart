import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/admin/screens/ManageProducts/addButton.dart';
import 'package:mobile_vault/panels/admin/screens/ManageProducts/readProducts.dart';

class AdminManageProducts extends StatefulWidget {
  const AdminManageProducts({super.key});

  @override
  State<AdminManageProducts> createState() => _AdminManageProductsState();
}

class _AdminManageProductsState extends State<AdminManageProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ReadProducts()), // Change to your desired layout
      floatingActionButton: const AddButton(),
    );
  }
}
