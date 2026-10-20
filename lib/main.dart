import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Profile App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchStudentProfile();
  }

  // Njia ya kuchukua taarifa kutoka Backend API
  Future<void> fetchStudentProfile() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/student'));
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          studentData = jsonResponse['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load student data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Connection error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        studentData?['fullName'] ?? 'N/A',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        studentData?['degreeProgram'] ?? 'N/A',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.badge, color: Colors.blue),
                                title: const Text('Student ID'),
                                subtitle: Text(studentData?['id'] ?? 'N/A'),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.email, color: Colors.blue),
                                title: const Text('Email Address'),
                                subtitle: Text(studentData?['email'] ?? 'N/A'),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.phone, color: Colors.blue),
                                title: const Text('Phone Number'),
                                subtitle: Text(studentData?['phone'] ?? 'N/A'),
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.school, color: Colors.blue),
                                title: const Text('Status'),
                                subtitle: Text(studentData?['status'] ?? 'Active'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}