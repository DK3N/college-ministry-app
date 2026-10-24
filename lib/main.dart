import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://mitbmqlmdkpqplrlrsah.supabase.co",
    publishableKey: "sb_publishable_1hzX6aGIdnsc4B7lXEKEcQ_rHMFc9mm"
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