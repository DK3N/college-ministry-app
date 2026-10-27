import 'package:flutter/material.dart';
import '../widgets/custom_back_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: const Positioned(
          top: 10,
          left: 10,
          child: CustomBackButton(),
        ),
      ),
    );
  }
}
