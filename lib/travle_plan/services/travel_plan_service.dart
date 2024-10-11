// travel_plan_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/travel_plan.dart';

class TravelPlanService {
  // 여행 계획 목록을 로컬 저장소에서 가져오기
  Future<List<TravelPlan>> getTravelPlans() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> travelPlanStrings = prefs.getStringList('travelPlans') ?? [];
    List<TravelPlan> travelPlans = travelPlanStrings
        .map((planString) => TravelPlan.fromJson(jsonDecode(planString)))
        .toList();
    return travelPlans;
  }

  // 새로운 여행 계획 추가하기
  Future<void> addTravelPlan(TravelPlan travelPlan) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> travelPlanStrings = prefs.getStringList('travelPlans') ?? [];
    travelPlanStrings.add(jsonEncode(travelPlan.toJson()));
    await prefs.setStringList('travelPlans', travelPlanStrings);
  }

  // 특정 여행 계획 삭제하기
  Future<void> removeTravelPlan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> travelPlanStrings = prefs.getStringList('travelPlans') ?? [];
    travelPlanStrings.removeWhere((planString) {
      final plan = TravelPlan.fromJson(jsonDecode(planString));
      return plan.id == id;
    });
    await prefs.setStringList('travelPlans', travelPlanStrings);
  }
}
