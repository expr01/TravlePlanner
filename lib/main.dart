import 'package:flutter/material.dart';
import 'schedule/pages/schedule_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Planner',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ScheduleListPage(), // 일정 조회 화면이 메인 페이지
    );
  }
}
