import 'package:flutter/material.dart';
import 'package:mobile_vault/services/database_product.dart';

class DeleteProducts extends StatelessWidget {
  final String productId; // Product ID required for deletion

  const DeleteProducts({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger =
        ScaffoldMessenger.of(context); // Capture before dialog
    return IconButton(
      onPressed: () async {
        bool? confirmed = await showDialog<bool>(
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

        if (confirmed == true) {
          try {
            await DatabaseProduct().deleteProduct(productId);
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text("Product deleted successfully!")),
            );
          } catch (e) {
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text("Failed to delete product: $e")),
            );
          }
        }
      },
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }
}
