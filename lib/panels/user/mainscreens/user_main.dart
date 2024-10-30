import 'package:flutter/material.dart';
import 'package:mobile_vault/panels/user/mainscreens/containers/categories.dart';
import 'package:mobile_vault/panels/user/mainscreens/containers/product_search_page.dart';
import 'package:mobile_vault/panels/user/mainscreens/containers/products.dart';
import 'package:mobile_vault/panels/user/mainscreens/containers/searchbar.dart';

class UserPage extends StatelessWidget {
  void onSearch(BuildContext context, String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductSearchPage(searchQuery: query),
      ),
    );
  }

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
      body: Container(
        color: Colors.red,
        child: Column(
          children: [
            Searchbar(onSearch: (query) => onSearch(context, query)),
            CategoriesPage(),
            Expanded(
              child: ProductsPage(
                searchQuery: '',
                category: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
