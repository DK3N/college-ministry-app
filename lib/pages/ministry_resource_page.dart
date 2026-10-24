import 'package:flutter/material.dart';

class MinistryResourcePage extends StatelessWidget {
  final String ministryName;

  const MinistryResourcePage({super.key, required this.ministryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$ministryName Resources'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),

              // Section: Giving Icon
              Row(
                children: const [
                  Icon(Icons.favorite, size: 40, color: Colors.red), // Giving icon
                  SizedBox(width: 10),
                  Text(
                    'Giving',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(),

              // Section: Upcoming Events
              const Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text('Midweek - Wednesday 10/9/24'),
                    Text('Church on Campus - Sunday 10/13/24'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Lessons
              const Text(
                'Lessons',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text('Lesson 1: Faith and Fellowship'),
                    Text('Lesson 2: Discipleship and Devotion'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section: Community Groups
              const Text(
                'Community Groups',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text('Group 1: Campus Leaders'),
                    Text('Group 2: Young Professionals'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
