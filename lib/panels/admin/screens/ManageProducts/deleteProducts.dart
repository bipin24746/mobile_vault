import 'package:flutter/material.dart';
import 'package:mobile_vault/services/database_product.dart';

class DeleteProducts extends StatelessWidget {
  final String productId; // Product ID required for deletion

  const DeleteProducts({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        bool confirmed = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Delete Product"),
            content: Text("Are you sure you want to delete this product?"),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text("Delete", style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );

        if (confirmed) {
          await DatabaseProduct().deleteProduct(productId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Product deleted successfully!")),
          );
        }
      },
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }
}
