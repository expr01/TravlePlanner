import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';
import 'add_schedule_page.dart';

class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage({super.key});

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  List<Schedule> _schedules = [];
  DateTime _focusedDay = DateTime.now();
  final DateTime _startDate = DateTime(2023, 1, 24); // 여행 시작 날짜
  final DateTime _endDate = DateTime(2023, 1, 27); // 여행 종료 날짜

  @override
  void initState() {
    super.initState();
    _loadSchedules();

    // 해결: focusedDay가 endDate를 넘지 않도록 조정
    if (_focusedDay.isAfter(_endDate)) {
      _focusedDay = _endDate;
    }
    if (_focusedDay.isBefore(_startDate)) {
      _focusedDay = _startDate;
    }
  }

  Future<void> _loadSchedules() async {
    List<Schedule> schedules = await ScheduleService().loadSchedules();
    setState(() {
      _schedules = schedules;
    });
  }

  void _addSchedule(DateTime selectedDate) async {
    final newSchedule = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedulePage(selectedDate: selectedDate),
      ),
    );

    if (newSchedule != null) {
      setState(() {
        _schedules.add(newSchedule);
      });
      await ScheduleService().saveSchedules(_schedules);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Trip',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('일본', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                '${DateFormat('yyyy.MM.dd').format(_startDate)} - ${DateFormat('yyyy.MM.dd').format(_endDate)}'),
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: _startDate,
            lastDay: _endDate,
            selectedDayPredicate: (day) =>
                day.isAfter(_startDate.subtract(const Duration(days: 1))) &&
                day.isBefore(_endDate.add(const Duration(days: 1))),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
              _addSchedule(selectedDay);
            },
            calendarFormat: CalendarFormat.month,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
              ),
            ),
          ),
          if (_schedules.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('일정을 추가해주세요', style: TextStyle(color: Colors.grey)),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _schedules.length,
                itemBuilder: (context, index) {
                  final schedule = _schedules[index];
                  return ListTile(
                    title: Text(schedule.title),
                    subtitle: Text(DateFormat('yyyy.MM.dd HH:mm')
                        .format(schedule.dateTime)),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _addSchedule(_focusedDay),
              child: const Text('일정 추가하기'),
            ),
          ),
        ],
      ),
    );
  }
}
