import 'package:flutter/material.dart';
import 'package:guftgu/files/loginSignup/UserAuthentication.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Authentication()
    );
  }
}
