import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_vault/Login%20Details/loginpage.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  // Function to send a password reset email
  passwordEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      // Show success message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password reset email sent!"),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      // Show error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    }
  }

  // TextEditingController for handling the email input
  TextEditingController sendEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Reset Your Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: sendEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Enter email",
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                if (sendEmail.text.isNotEmpty) {
                  passwordEmail(sendEmail.text); // Call function to send email
                } else {
                  // Show error if email field is empty
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter your email!"),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: Text(
                "Send Password Reset Email",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Remember Password? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Loginpage()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
