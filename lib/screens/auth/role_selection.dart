import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  void selectRole(BuildContext context, String role) {
    Navigator.pushNamed(context, '/register', arguments: role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => selectRole(context, 'admin'),
              child: const Text('Admin'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => selectRole(context, 'student'),
              child: const Text('Student'),
            ),
          ],
        ),
      ),
    );
  }
}
