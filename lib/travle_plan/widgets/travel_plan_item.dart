import 'package:flutter/material.dart';
import '../models/travel_plan.dart';

class TravelPlanItem extends StatelessWidget {
  final TravelPlan travelPlan; // 모델에 정의

  TravelPlanItem({
    required this.travelPlan,
  });

  @override
  Widget build(BuildContext context) {
    return Card( // Card 위젯 사용
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding( // 카드 내 padding 적용
        padding: const EdgeInsets.all(12.0),
        child: Column( // 수직 위젯 배치
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( // 여행 계획 정보 표시
              travelPlan.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              '${travelPlan.startDate.toLocal()} - ${travelPlan.endDate.toLocal()}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}