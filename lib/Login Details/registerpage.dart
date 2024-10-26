import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';
import 'package:mobile_vault/Login%20Details/loginpage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  TextEditingController userName = TextEditingController();
  TextEditingController mobileNum = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    String name = userName.text.trim();
    String mobile = mobileNum.text.trim();
    String email = emailAddress.text.trim();
    String password = newPassword.text.trim();
    String confirmpassword = confirmPassword.text.trim();

    // Validate fields
    if (name.isEmpty ||
        mobile.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      showMessage("Please fill in all fields.");
      return;
    }

    if (password != confirmpassword) {
      showMessage("Passwords don't match");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user role in Firestore
      String role = "user"; // Default role
      QuerySnapshot users =
          await FirebaseFirestore.instance.collection('users').get();

      // Check if this is the first user
      if (users.docs.isEmpty) {
        role = "admin"; // Assign admin role to the first user
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'mobile': mobile, // Save mobile number
        'role': role, // Save role
      });

      showMessage(
          "Registration Successful. User: ${userCredential.user!.email}");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Loginpage()));
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication exceptions
      if (e.code == 'weak-password') {
        showMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showMessage('An account already exists for that email.');
      } else {
        showMessage(e.message.toString());
      }
    } catch (e) {
      showMessage("Error: ${e.toString()}");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text("Create Account",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: registerKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: userName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Full Name",
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: mobileNum,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Mobile Number",
                    prefixIcon: const Icon(Icons.call),
                  ),
                  keyboardType: TextInputType.phone, // Changed to phone type
                ),
              ),
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
                  controller: newPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: registerUser,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Sign Up",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              const Text("Already Have An Account?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Loginpage()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Login",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
