import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String selectedRole = 'student'; // Default role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Role'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your role',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Student role button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedRole == 'student' ? Colors.blue : Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                setState(() {
                  selectedRole = 'student';
                });
              },
              child: Text('Student', style: TextStyle(fontSize: 18)),
            ),

            SizedBox(height: 20),

            // Teacher role button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedRole == 'teacher' ? Colors.blue : Colors.grey,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                setState(() {
                  selectedRole = 'teacher';
                });
              },
              child: Text('Teacher', style: TextStyle(fontSize: 18)),
            ),

            SizedBox(height: 40),

            // Continue button
            ElevatedButton(
              onPressed: () {
                // Navigate to registration with the selected role
                Navigator.pushNamed(
                  context,
                  '/register',
                  arguments: {'role': selectedRole},
                );
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}