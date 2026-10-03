import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ministry_selection_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;

  Future<void> _login() async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (response.error != null) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.error!.message)));
    } else {
      // Successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MinistrySelectionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Stack(
        children: [
          SingleChildScrollView( // Make content scrollable when keyboard pops up
            child: Container(
              height: MediaQuery.of(context).size.height, // Ensure the container takes full height
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xF8D909B), Color(0xFF4d80d1)], // Gradient background
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Rounded container for the form
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,  // 75% of screen height
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Spacer(),
                              const Text(
                                'Welcome!',
                                textAlign: TextAlign.center,  // Center the text itself
                                style: TextStyle(
                                  fontSize: 50,
                                  fontFamily: 'Caprasimo',
                                  color: Color(0xFF5A6FC4), // Dark blue color for the title
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Email field
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(
                                  fontFamily: 'Yeseva',  // Specify the font family here
                                  fontSize: 16,
                                  color: Colors.black,  // Text color inside the form field
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Yeseva',  // Specify the font family for the label
                                    fontSize: 16,
                                    color: Colors.black54,  // Color of the label
                                  ),
                                  prefixIcon: Icon(Icons.email),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Password field
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(
                                  fontFamily: 'Yeseva',  // Specify the font family here
                                  fontSize: 16,
                                  color: Colors.black,  // Text color inside the form field
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Yeseva',  // Specify the font family for the label
                                    fontSize: 16,
                                    color: Colors.black54,  // Color of the label
                                  ),
                                  prefixIcon: Icon(Icons.lock),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Create an Account button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _login,  // Call the _login function here
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    backgroundColor: const Color(0xFF5A6FC4), // Button color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(fontFamily: 'Yeseva', fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Already have an account link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Having trouble?",
                                    style: TextStyle(fontFamily: 'Yeseva', color: Colors.black54),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const LoginPage()),
                                      ); // Go back to WelcomePage
                                    },
                                    child: const Text(
                                      "Forgot my Password",
                                      style: TextStyle(
                                        fontFamily: 'Yeseva',
                                        color: Color(0xFF5A6FC4),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // "Don't have an account? Sign up here" link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(fontFamily: 'Yeseva', color: Colors.black54),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                                      ); // Navigate to the sign-up page
                                    },
                                    child: const Text(
                                      "Sign up here",
                                      style: TextStyle(
                                        fontFamily: 'Yeseva',
                                        color: Color(0xFF5A6FC4),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Back Button in the top-left corner
          Positioned(
            top: 40,  // Adjust based on how much padding you need
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
          ),
        ],
      ),
    );
  }
}