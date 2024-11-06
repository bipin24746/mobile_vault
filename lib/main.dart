import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_vault/Login%20Details/loginpage.dart'; // Adjust the import as necessary

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding is initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Vault',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Loginpage(), // Use your login page as the home
    );
  }
}
