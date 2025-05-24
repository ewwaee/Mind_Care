import 'package:doctor_app_fixed/pages/welcome_page.dart';
import 'package:doctor_app_fixed/theme/colors.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primary,
      ),
      home: const WelcomePage(),
    );
  }
}


