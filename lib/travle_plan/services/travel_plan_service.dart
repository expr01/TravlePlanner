import 'package:flutter/material.dart';
import '../models/travel_plan.dart';

class TravelPlanService {
  // 임시로 메모리에 데이터를 저장하는 리스트 (실제로는 로컬 데이터베이스나 API와 통신 가능)
  final List<TravelPlan> _travelPlans = [
    TravelPlan(
      id: '1',
      title: 'First Trip',
      startDate: DateTime(2023, 1, 5),
      endDate: DateTime(2023, 1, 7),
      destination: 'Seoul',
    ),
    TravelPlan(
      id: '2',
      title: 'Second Trip',
      startDate: DateTime(2023, 2, 10),
      endDate: DateTime(2023, 2, 15),
      destination: 'Tokyo',
    ),
    TravelPlan(
      id: '3',
      title: 'Third Trip',
      startDate: DateTime(2023, 3, 20),
      endDate: DateTime(2023, 3, 25),
      destination: 'New York',
    ),
  ];

  // 여행 계획 목록 가져오기 (전체 목록 조회)
  Future<List<TravelPlan>> getTravelPlans() async {
    // 실제로는 데이터베이스나 네트워크 요청이 들어갈 수 있음
    await Future.delayed(Duration(milliseconds: 500)); // 로딩 시뮬레이션
    return _travelPlans;
  }
}
