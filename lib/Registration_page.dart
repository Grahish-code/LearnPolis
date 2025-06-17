import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isLevel2 = false;

  String? selectedBranch;
  String? selectedYear;
  String? selectedGoal;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final List<String> branches = [
    'Computer Engineering',
    'Civil Engineering',
    'Mechanical Engineering',
    'Electrical Engineering',
    'Electronics and Telecommunication',
  ];

  final List<String> years = ['First Year', 'Second Year', 'Third Year', 'Final Year'];

  final List<String> goals = [
    'Software Developer',
    'Civil Engineer',
    'Mechanical Engineer',
    'Hacker',
    'Data Scientist',
    'Business Analyst',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A192F),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: isLevel2 ? _buildLevel2() : _buildLevel1(),
        ),
      ),
    );
  }

  Widget _buildLevel1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Image.asset('assets/main_logo.png', height: 60, alignment: Alignment.center),
        const SizedBox(height: 10),
        const Text('TechQuest', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center),
        const SizedBox(height: 5),
        const Text('Where Engineering Meets Innovation', style: TextStyle(color: Colors.grey, fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        const Text('Complete your profile to start your journey', style: TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 10),
        const LinearProgressIndicator(value: 0.33, backgroundColor: Color(0xFF172A46), valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        const SizedBox(height: 5),
        const Text('Level 1: Profile Creation', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 20),

        _buildTextField('Choose Your Username', Icons.person, 'Enter username', controller: usernameController),
        const SizedBox(height: 15),
        _buildTextField('Enter Your Email', Icons.email, 'name@example.com', controller: emailController),
        const SizedBox(height: 15),
        _buildTextField('Create Your Password', Icons.lock, 'Min. 8 characters', isPassword: true, controller: passwordController),
        const SizedBox(height: 30),

        const Center(child: Text('Quick Power-Up', style: TextStyle(color: Colors.white))),
        const SizedBox(height: 10),
        const Text('Quick Login Options', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Continue with Google', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Optional: Add form validation here
            if (usernameController.text.isEmpty ||
                emailController.text.isEmpty ||
                passwordController.text.length < 8) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill all fields with valid data")),
              );
              return;
            }

            setState(() {
              isLevel2 = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Begin Adventure'),
        ),
        const SizedBox(height: 20),
        const Text('By continuing, you agree to our Terms & Privacy Policy',
            textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildLevel2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        Image.asset('assets/main_logo.png', height: 60, alignment: Alignment.center),
        const SizedBox(height: 10),
        const Text('TechQuest', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center),
        const SizedBox(height: 5),
        const Text('Where Engineering Meets Innovation', style: TextStyle(color: Colors.grey, fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        const Text('Almost there! Complete your academic info', style: TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 10),
        const LinearProgressIndicator(value: 0.66, backgroundColor: Color(0xFF172A46), valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        const SizedBox(height: 5),
        const Text('Level 2: Academic Information', style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 30),

        const Text('Which branch are you studying?', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedBranch,
          dropdownColor: const Color(0xFF172A46),
          items: branches.map((String branch) {
            return DropdownMenuItem<String>(
              value: branch,
              child: Text(branch, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedBranch = value;
            });
          },
          decoration: _dropdownDecoration(),
        ),
        const SizedBox(height: 15),

        const Text('Which year are you in?', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedYear,
          dropdownColor: const Color(0xFF172A46),
          items: years.map((String year) {
            return DropdownMenuItem<String>(
              value: year,
              child: Text(year, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedYear = value;
            });
          },
          decoration: _dropdownDecoration(),
        ),
        const SizedBox(height: 15),

        const Text('What is your ultimate goal as an engineer?', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: selectedGoal,
          dropdownColor: const Color(0xFF172A46),
          items: goals.map((String goal) {
            return DropdownMenuItem<String>(
              value: goal,
              child: Text(goal, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGoal = value;
            });
          },
          decoration: _dropdownDecoration(),
        ),
        const SizedBox(height: 30),

        ElevatedButton(
          onPressed: () async {
            try {
              // 1. Create user in Firebase Auth (handles password securely)
              final credential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );

              // 2. Store additional user data in Firestore (without password)
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(credential.user!.uid) // Use UID from Firebase Auth as document ID
                  .set({
                'username': usernameController.text.trim(),
                'email': emailController.text.trim(),
                'branch': selectedBranch,
                'year': selectedYear,
                'goal': selectedGoal,
                'timestamp': FieldValue.serverTimestamp(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration successful!")),
              );
            } on FirebaseAuthException catch (e) {
              String errorMessage = "Registration failed";
              if (e.code == 'weak-password') {
                errorMessage = "Password is too weak";
              } else if (e.code == 'email-already-in-use') {
                errorMessage = "Email already registered";
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${e.toString()}")),
              );
            }
          },
          child: const Text('Complete Registration'),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon, String hintText, {bool isPassword = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF172A46),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF172A46),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    );
  }
}
