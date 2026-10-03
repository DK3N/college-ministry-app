import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/sign_up_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iqgjkoxtiqfdmqguuwdx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxZ2prb3h0aXFmZG1xZ3V1d2R4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc1Mzg5MzYsImV4cCI6MjA0MzExNDkzNn0.tY7KyO5xglA50WlS1ksRtV9fLiT99ydcMU1oxe9xLCI',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Church App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),  // Starting point of the app
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF),  // Light color at the top
              Color(0xFFd4c9ff),  // Slightly darker color at the bottom
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(flex:1), // Pushes the content down
                // Church Icon (Placeholder for now, replace with your asset)
                const Text(
                  'Connect',
                  style: TextStyle(
                    fontFamily: 'Caprasimo', // The custom font family declared
                    fontSize: 72,
                    //fontWeight: FontWeight.bold,
                    color: Color(0xFF153243),
                  ),
                ),
                const SizedBox(height: 10),
                // Subtitle Text
                const Text(
                  'Bridging Faith and Community',
                  style: TextStyle(
                    fontFamily: 'Yeseva',
                    fontSize: 18,
                    //color: Colors.black54,
                    color: Color(0xFF153243),
                  ),
                ),
                const Spacer(flex:1),
                Image.asset(
                  'lib/assets/images/church_icon.png',
                  height: 250,
                ),
                const Spacer(flex:1),
                // Create an Account Button
                SizedBox(
                  width: 250, // Set the desired width for both buttons
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Color(0xFF000b1c); // Color when the button is pressed
                        }
                        return const Color(0xFF001A44); // Default color when not pressed
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded button
                        ),
                      ),
                    ),
                    child: const Text(
                      'Create an account',
                      style: TextStyle(fontSize: 18, fontFamily: 'Yeseva', color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15), // Space between buttons
                // Login Button
                SizedBox(
                  width: 250, // Set the desired width for both buttons
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Color(0xFF193b5c); // Color when the button is pressed
                        }
                        return const Color(0xFF3E6990); // Default color when not pressed
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded button
                        ),
                      ),
                    ),

                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, fontFamily: 'Yeseva', color: Colors.white),
                    ),
                  ),
                ),
                const Spacer(),
                // Terms & Policy Text
                const Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: const [
                      Text(
                        'By continuing you agree to our',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      Text(
                        'Terms & Policy',
                        style: TextStyle(
                          color: Color(0xFF001A44), // Same dark blue color
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
