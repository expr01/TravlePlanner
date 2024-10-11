// travel_plan_detail_page.dart
import 'package:flutter/material.dart';
import '../models/travel_plan.dart';

class TravelPlanDetailPage extends StatelessWidget {
  final TravelPlan travelPlan;

  TravelPlanDetailPage({required this.travelPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 계획 상세보기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              travelPlan.title,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              '날짜: ${travelPlan.startDate.year}년 ${travelPlan.startDate.month}월 ${travelPlan.startDate.day}일 - ${travelPlan.endDate.year}년 ${travelPlan.endDate.month}월 ${travelPlan.endDate.day}일',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              '목적지: ${travelPlan.destination}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Text(
              '메모:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              travelPlan.memo,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}