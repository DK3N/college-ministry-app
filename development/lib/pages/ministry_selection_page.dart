import 'package:flutter/material.dart';
import 'ministry_resource_page.dart';

class MinistrySelectionPage extends StatefulWidget {
  const MinistrySelectionPage({super.key});

  @override
  _MinistrySelectionPageState createState() => _MinistrySelectionPageState();
}

class _MinistrySelectionPageState extends State<MinistrySelectionPage> {
  String? selectedMinistry; // Variable to hold the selected ministry

  final List<String> ministries = [
    'Coastal Church',
    'Southwest Florida Church of Christ',
    'Space Coast Church of Christ',
    'South Florida Church of Christ',
    'Orlando Church of Christ',
    'Sarasota Church of Christ',
    '1200 Tharpe Street Church',
    'Cross Way Church',
    'Jacksonville Church of Christ',
    'South Lake Church',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Ministry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "First, let's find your ministry!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 10.0,
                ),
              ),
              value: selectedMinistry,
              hint: const Text('Select your ministry'),
              items: ministries.map((String ministry) {
                return DropdownMenuItem<String>(
                  value: ministry,
                  child: Text(ministry),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMinistry = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic for going to resource page
                if (selectedMinistry != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MinistryResourcePage(
                        ministryName: selectedMinistry!,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a ministry')),
                  );
                }
              },
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
