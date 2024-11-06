import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/admin/screens/ManageProducts/manage_products.dart';

class ManageProductsAdmin extends StatelessWidget {
  const ManageProductsAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 130,
          width: 130,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminManageProducts()));
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.orange,
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Manage Products",
                  textAlign: TextAlign.center, // Center text in the Text widget
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
