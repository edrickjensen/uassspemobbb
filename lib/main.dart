import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/sketch_screen.dart'; // Layar sketsa Anda
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';  // Layar login Anda

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SketchApp(),  // Ganti ini dengan widget utama kamu
    );
  }
}

class SketchApp extends StatefulWidget {
  @override
  _SketchAppState createState() => _SketchAppState();
}

class _SketchAppState extends State<SketchApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Inisialisasi FirebaseAuth

  // Fungsi untuk memeriksa status login pengguna
  void _checkUserLogin() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // Pengguna sudah login
      print('User is logged in: ${user.email}');
    } else {
      // Pengguna belum login
      print('No user is logged in');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserLogin();  // Panggil _checkUserLogin saat aplikasi dimulai
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sketch App'),
      ),
      body: Center(
        child: Text('Welcome to the Sketch App!'),
      ),
    );
  }
}
