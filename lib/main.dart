// main.dart
import 'package:flutter/material.dart';
import 'package:travleplanner/main/pages/main_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
    );
  }
}
