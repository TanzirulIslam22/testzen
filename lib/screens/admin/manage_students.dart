import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testzen/services/auth_service.dart';
// Adding this since it was referenced but not defined in the original code
// class AuthService {
//   Future<void> createStudentAccount(String email, String password, String name) async {
//     // Implement Firebase Auth user creation
//     // This would typically use Firebase Authentication and then create a Firestore document
//
//     // Example implementation:
//     // 1. Create auth user
//     // final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//     //   email: email,
//     //   password: password,
//     // );
//
//     // 2. Create Firestore record
//     // await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
//     //   'name': name,
//     //   'email': email,
//     //   'role': 'student',
//     //   'createdAt': FieldValue.serverTimestamp(),
//     // });
//   }
// }

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({Key? key}) : super(key: key);

  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Students',
                hintText: 'Enter name or email',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'student')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No students found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                var students = snapshot.data!.docs;

                // Filter based on search query
                if (_searchQuery.isNotEmpty) {
                  students = students.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['name'] ?? '').toString().toLowerCase();
                    final email = (data['email'] ?? '').toString().toLowerCase();
                    final query = _searchQuery.toLowerCase();
                    return name.contains(query) || email.contains(query);
                  }).toList();
                }

                if (students.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No students match "${_searchController.text}"',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index].data() as Map<String, dynamic>;
                    final studentId = students[index].id;
                    final name = student['name'] ?? 'Unknown Student';
                    final email = student['email'] ?? 'No email';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(name[0].toUpperCase()),
                        ),
                        title: Text(name),
                        subtitle: Text(email),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _showStudentActionDialog(context, studentId, name);
                          },
                        ),
                        onTap: () {
                          // TODO: Navigate to student details
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Student details coming soon')),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStudentDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showStudentActionDialog(BuildContext context, String studentId, String studentName) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(studentName),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                // TODO: View student details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student details coming soon')),
                );
              },
              child: const Text('View Details'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _showAssignTestsDialog(context, studentId, studentName);
              },
              child: const Text('Assign Tests'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                _showRemoveStudentDialog(context, studentId, studentName);
              },
              child: const Text('Remove Student', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;
    String _errorMessage = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Student'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter student name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = '';
                      });

                      try {
                        // Create Firebase Auth user
                        final authService = AuthService();
                        await authService.createStudentAccount(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim(),
                        );

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Student added successfully')),
                        );
                      } catch (e) {
                        setState(() {
                          _errorMessage = e.toString();
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Add Student'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
    });
  }

  void _showRemoveStudentDialog(BuildContext context, String studentId, String studentName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Student'),
          content: Text('Are you sure you want to remove $studentName? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  // Delete user document
                  await FirebaseFirestore.instance.collection('users').doc(studentId).delete();
                  // Note: This doesn't delete the actual Firebase Auth user, only the Firestore record

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Student removed successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAssignTestsDialog(BuildContext context, String studentId, String studentName) {
    bool _isLoading = false;
    List<String> _selectedTests = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Assign Tests to $studentName'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('tests')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No tests available'),
                          );
                        }

                        final tests = snapshot.data!.docs;

                        return SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: tests.length,
                            itemBuilder: (context, index) {
                              final test = tests[index].data() as Map<String, dynamic>;
                              final testId = tests[index].id;
                              final testName = test['name'] ?? 'Unnamed Test';

                              return CheckboxListTile(
                                title: Text(testName),
                                subtitle: Text(test['description'] ?? ''),
                                value: _selectedTests.contains(testId),
                                onChanged: (selected) {
                                  setState(() {
                                    if (selected!) {
                                      _selectedTests.add(testId);
                                    } else {
                                      _selectedTests.remove(testId);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isLoading || _selectedTests.isEmpty
                      ? null
                      : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      // Assign tests to student
                      for (final testId in _selectedTests) {
                        await FirebaseFirestore.instance
                            .collection('studentTests')
                            .add({
                          'studentId': studentId,
                          'testId': testId,
                          'assignedAt': FieldValue.serverTimestamp(),
                          'completed': false,
                        });
                      }

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${_selectedTests.length} tests assigned to $studentName'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Assign Tests'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}