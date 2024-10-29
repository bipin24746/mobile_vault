import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/admin/screens/ManageProducts/add_Product.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProducts()),
        );
      },
      child: Icon(Icons.add),
    );
  }
}
