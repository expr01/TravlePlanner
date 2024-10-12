import 'package:flutter/material.dart';
import 'package:travelplanner/main/pages/main_page.dart';
import 'package:travelplanner/travle_plan/pages/travel_plan_list_page.dart';
import 'package:travelplanner/travle_plan/pages/travel_plan_add_page.dart';
import 'package:travelplanner/travle_plan/pages/travel_plan_detail_page.dart';
import 'package:travelplanner/travle_plan/models/travel_plan.dart';

void main() {
  runApp(MyApp()); // const 제거
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
      routes: {
        '/list': (context) => TravelPlanListPage(),
        '/add': (context) => TravelPlanAddPage(),
        '/detail': (context) => TravelPlanDetailPage(
          travelPlan: ModalRoute.of(context)!.settings.arguments as TravelPlan,
        ),
      },
    );
  }
}
