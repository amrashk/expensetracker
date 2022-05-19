
import 'package:flutter/material.dart';


void main() {
  runApp(const MaterialApp());
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
  }