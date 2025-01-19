import 'package:flutter/material.dart';
// import 'package:task_manage_sys1/frontend/home_screen.dart';
import 'package:task_manage_sys1/frontend/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: LoginScreen(),
      // home: HomeScreen(),
    );
  }
}
