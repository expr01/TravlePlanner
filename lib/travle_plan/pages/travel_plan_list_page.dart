// 여행 계획 목록 페이지
import 'package:flutter/material.dart';
import '../models/travel_plan.dart';
import '../services/travel_plan_service.dart';
import '../widgets/travel_plan_item.dart';

// 클래스 선언부 StatefulWidget -> 상태 관리 가능 (동적 페이지 구성)
class TravelPlanListPage extends StatefulWidget {
  const TravelPlanListPage({super.key}); // 위젯 동적 생성 시 key 사용해 구분 위함

  @override
  _TravelPlanListPageState createState() => _TravelPlanListPageState();
}

class _TravelPlanListPageState extends State<TravelPlanListPage> { // 상태 관리 클래스
  final TravelPlanService _travelPlanService = TravelPlanService();
  List<TravelPlan> _travelPlans = [];

  @override
  void initState() { // 여행 계획 데이터 로드 위해 _loadTravelPlans()를 호출
    super.initState();
    _loadTravelPlans();
  }

  void _loadTravelPlans() async { // 여행 데이터 가져옴
    List<TravelPlan> plans = await _travelPlanService.getTravelPlans();
    setState(() {
      _travelPlans = plans;
    });
  }

  @override
  Widget build(BuildContext context) { // Scaffold 위젯 사용, 페이지 기본 구조 설정
    return Scaffold(
      appBar: AppBar(
        title: Text('내 여행'),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[200],
        child: _travelPlans.isEmpty
            ? Center(
          child: Text( // 여행 계획 없을 때
            '여행 계획이 없습니다.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder( // 여행 계획 있다면?
          itemCount: _travelPlans.length,
          itemBuilder: (context, index) {
            final travelPlan = _travelPlans[index];
            return TravelPlanItem(
              travelPlan: travelPlan,
            );
          },
        ),
      ),
    );
  }
}