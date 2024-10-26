import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:mobile_vault/Login%20Details/forgetpassword.dart';
import 'package:mobile_vault/Login%20Details/registerpage.dart';
import 'package:mobile_vault/panels/user/screens/homepage.dart';
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
  bool obsecureText = true; // For hiding/showing password

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

      // Retry logic for fetching user role
      DocumentSnapshot? userDoc; // Make userDoc nullable
      bool fetched = false;
      for (int i = 0; i < 3; i++) {
        // Retry 3 times
        try {
          userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();
          fetched = true;
          break; // Exit loop if successful
        } catch (e) {
          if (i < 2) {
            // If it's not the last attempt, wait and retry
            await Future.delayed(const Duration(seconds: 2));
          }
        }
      }

      if (!fetched) {
        throw Exception(
            "Failed to fetch user document after multiple attempts.");
      }
      if (userDoc != null && userDoc.exists) {
        // Check if userDoc is not null
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
          // Corrected else statement
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UserPage()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User document does not exist.")));
      }
    } on FirebaseAuthException catch (e) {
      // Handle login errors (same as your existing implementation)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
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
            const Padding(
              padding: EdgeInsets.only(top: 90, left: 50),
              child: Text("Enter Login Details",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text("Enter Your Email",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Enter Your Email",
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text("Enter Your Password",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: loginPassword,
                obscureText: obsecureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Enter Your Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecureText = !obsecureText; // Toggle visibility
                      });
                    },
                    icon: Icon(
                        obsecureText ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetPassword()));
                    },
                    child: Text("Forget Password?"),
                  )
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: loginUser,
                child:
                    const Text("Login", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  const Text("Don't have an account?"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Registerpage()));
                    },
                    child: const Text("Create Account",
                        style: TextStyle(color: Colors.white)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
