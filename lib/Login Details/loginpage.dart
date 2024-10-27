import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:mobile_vault/Login%20Details/forgetpassword.dart';
import 'package:mobile_vault/Login%20Details/registerpage.dart';
import 'package:mobile_vault/panels/admin/screens/admin_home.dart';
import 'package:mobile_vault/panels/user/user_main.dart'; // Import your admin home screen

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController emailAddress = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  bool obsecureText = true;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    String email = emailAddress.text.trim();
    String password = loginPassword.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both fields.")),
      );
      return;
    }

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Fetch user role
      DocumentSnapshot? userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        print("User role fetched: $role"); // Debug statement
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Login Successful, ${userCredential.user!.email}, Role: $role")));

        // Navigate based on role
        if (role == "admin") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AdminHome()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserPage()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User document does not exist.")));
      }
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      if (mounted) {
        // Only show SnackBar if the widget is still mounted
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("LoginPage",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Email ID",
                  prefixIcon: const Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress, // Added email type
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: loginPassword,
                obscureText: obsecureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                        obsecureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obsecureText =
                            !obsecureText; // Toggle password visibility
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: loginUser,
              child: const Text("Login", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            const SizedBox(height: 10),
            const Text("Don't Have An Account?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Registerpage()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Register",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
