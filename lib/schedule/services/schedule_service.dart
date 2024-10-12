import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/schedule.dart';

class ScheduleService {
  static const String _key = 'schedules';

  // 일정 목록 저장
  Future<void> saveSchedules(List<Schedule> schedules) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scheduleData =
        schedules.map((schedule) => jsonEncode(schedule.toMap())).toList();
    prefs.setStringList(_key, scheduleData);
  }

  // 일정 목록 불러오기
  Future<List<Schedule>> loadSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? scheduleData = prefs.getStringList(_key);
    if (scheduleData != null) {
      return scheduleData
          .map((data) => Schedule.fromMap(jsonDecode(data)))
          .toList();
    }
    return [];
  }
}
