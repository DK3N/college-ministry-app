import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('PUBLIC_SUPABASE_URL'),
    publishableKey: const String.fromEnvironment('PUBLIC_SUPABASE_PUBLISHABLE_KEY')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disciples on Campus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),  // Starting point of the app
    );
  }
}