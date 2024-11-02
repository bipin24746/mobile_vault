import 'package:flutter/material.dart';
import 'package:mobile_vault/services/database_order.dart'; // Adjust the path as necessary

class BuyNowPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String userId;

  const BuyNowPage({
    Key? key,
    required this.product,
    required this.userId,
  }) : super(key: key);

  @override
  _BuyNowPageState createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int _quantity = 1;

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      // Create a product list with the product details
      List<Map<String, dynamic>> products = [
        {
          'productId': widget.product['id'],
          'title': widget.product['title'],
          'price': widget.product['price'],
          'quantity': _quantity,
          'imageUrl': widget.product['imageUrl'],
        }
      ];

      // Store the user details and product information in the database
      await DatabaseOrder().placeOrder(
        widget.userId,
        _nameController.text,
        _addressController.text,
        _mobileController.text,
        _emailController.text,
        products,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Order placed successfully!"),
      ));

      // Optionally, navigate back or to another page
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final title = product['title'] ?? 'No Title';
    final price = product['price']?.toString() ?? '0';
    final imageUrl = product['imageUrl'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Now"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Product Image
              Image.network(imageUrl),
              SizedBox(height: 10),
              Text(title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Rs. $price", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),

              // Quantity selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Quantity: $_quantity"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // User Details Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mobileController,
                      decoration: InputDecoration(labelText: 'Mobile Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitOrder,
                      child: Text("Submit Order"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
