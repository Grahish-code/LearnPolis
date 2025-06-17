import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_quest/Registration_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscureText = true; // State to toggle password visibility

  void login() async {
    try {
      // 1. Authenticate with Firebase Auth
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 2. Get additional user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (userDoc.exists) {
        // 3. Save user data to SharedPreferences (optional)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', userDoc['username']);
        await prefs.setString('email', userDoc['email']);

        // 4. Navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage(username: userDoc['username'])),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Login failed";
      if (e.code == 'user-not-found') {
        errorMessage = "User not found";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/main_logo.png',
                          height: 70,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // App Name
                      const Text(
                        'LearnoPolis',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Where Engineering meets Innovation',
                        style: TextStyle(fontSize: 18, color: Colors.white), // White text
                      ),
                      const SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850], // Dark grey with transparency
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildInputField('Username', usernameController, 'assets/user.svg'),
                            const SizedBox(height: 15),
                            buildInputField('Email', emailController, 'assets/email.svg'),
                            const SizedBox(height: 15),
                            buildInputField('Password', passwordController, 'assets/lock.svg', isPassword: true),
                            const SizedBox(height: 20),

                            isLoading
                                ? const CircularProgressIndicator(color: Colors.blue)
                                : ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text('Quick Login Options', style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text('Continue with Google', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('New to LearnoPolis?', style: TextStyle(color: Colors.white)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationPage()));
                            },
                            child: const Text('Create Account', style: TextStyle(color: Colors.blue, fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, String iconPath, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false, // Toggle visibility for password
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: 'Enter your $label',
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(iconPath, width: 20, height: 20, color: Colors.white),
        ),
        // Add suffix icon for password field to toggle visibility
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.white54,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // Toggle the obscureText state
            });
          },
        )
            : null,
      ),
    );
  }
}