import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travelplanner/travle_plan/models/travel_plan.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';
import 'add_schedule_page.dart';
import '../widgets/custom_button.dart';

class ScheduleListPage extends StatefulWidget {
  final TravelPlan travelPlan; // nullable이 아니므로 null이 아님

  const ScheduleListPage({super.key, required this.travelPlan});

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  List<Schedule> _schedules = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate; // 선택된 날짜

  @override
  void initState() {
    super.initState();

    // travelPlan에서 여행 시작일과 종료일을 가져옴
    final DateTime startDate = widget.travelPlan.startDate;
    final DateTime endDate = widget.travelPlan.endDate;

    // 현재 날짜가 lastDay 이후라면 focusedDay를 lastDay로 설정
    if (DateTime.now().isAfter(endDate)) {
      _focusedDay = endDate;
    } else if (DateTime.now().isBefore(startDate)) {
      _focusedDay = startDate;
    } else {
      _focusedDay = DateTime.now();
    }

    _selectedDate = _focusedDay;
    _loadSchedules(); // 일정 데이터를 불러오는 함수
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
        builder: (context) => AddSchedulePage(
          selectedDate: selectedDate,
          travelPlan: widget.travelPlan, // 명시적으로 widget.travelPlan 전달
        ),
      ),
    );

    if (newSchedule != null) {
      setState(() {
        _schedules.add(newSchedule);
        _schedules.sort((a, b) => a.dateTime.compareTo(b.dateTime)); // 시간별로 정렬
      });
      await ScheduleService().saveSchedules(_schedules);
    }
  }

  void _editSchedule(Schedule schedule) async {
    final updatedSchedule = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSchedulePage(
          selectedDate: schedule.dateTime,
          schedule: schedule, // 수정할 스케줄 전달
          travelPlan: widget.travelPlan, // travelPlan 전달
        ),
      ),
    );

    if (updatedSchedule != null) {
      setState(() {
        int index = _schedules.indexOf(schedule);
        _schedules[index] = updatedSchedule; // 해당 스케줄 수정
        _schedules.sort((a, b) => a.dateTime.compareTo(b.dateTime)); // 시간별 정렬
      });
      await ScheduleService().saveSchedules(_schedules);
    }
  }

  // 삭제 확인 다이얼로그
  void _showDeleteDialog(BuildContext context, Schedule schedule) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFDDE4D2), // 다이얼로그 배경색
          title: const Text(
            '삭제 확인',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text('일정을 삭제하시겠습니까?', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 취소
              },
              child: const Text('취소', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _deleteSchedule(schedule); // 삭제 처리
                Navigator.of(context).pop();
              },
              child: const Text(
                '삭제',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteSchedule(Schedule schedule) async {
    setState(() {
      _schedules.remove(schedule);
    });
    await ScheduleService().saveSchedules(_schedules); // 로컬 스토리지에서 삭제
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E6E1), // 전체 배경 색상 수정
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.travelPlan.title, // TravelPlan의 title 값 사용
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.travelPlan.destination, // TravelPlan의 destination 값 사용
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          // 상단 우측 날짜 박스 디자인
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${DateFormat('yyyy.MM.dd').format(widget.travelPlan.startDate)} - ${DateFormat('yyyy.MM.dd').format(widget.travelPlan.endDate)}',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 달력
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: widget.travelPlan.startDate, // TravelPlan의 startDate 사용
            lastDay: widget.travelPlan.endDate, // TravelPlan의 endDate 사용
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDate = selectedDay;
              });
            },
            calendarFormat: CalendarFormat.month, // "2 weeks" 버튼 제거하기 위해 고정
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month', // 다른 포맷 제공하지 않음
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.white60,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: Colors.black, // 첫 번째 날짜의 글자 색상을 검은색으로 설정
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
              ),
              // 전체 여행 날짜 범위 강조
              rangeHighlightColor: Colors.white60,
              // 범위 내 날짜 색상
              withinRangeDecoration: BoxDecoration(
                color: Colors.white60,
                shape: BoxShape.circle,
              ),
              // 범위 시작일 (첫 번째 날짜)
              rangeStartDecoration: BoxDecoration(
                color: Colors.white60, // 원하는 색상으로 수정
                shape: BoxShape.circle,
              ),
              rangeStartTextStyle: TextStyle(
                color: Colors.black, // 첫 번째 날짜의 글자 색상을 검은색으로 설정
              ),
              // 범위 종료일 (마지막 날짜)
              rangeEndDecoration: BoxDecoration(
                color: Colors.white60, // 원하는 색상으로 수정
                shape: BoxShape.circle,
              ),
              rangeEndTextStyle: TextStyle(
                color: Colors.black, // 마지막 날짜의 글자 색상을 검은색으로 설정
              ),
            ),
            rangeStartDay: widget.travelPlan.startDate,
            rangeEndDay: widget.travelPlan.endDate,
          ),
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat('yyyy년 M월 d일').format(_selectedDate!), // 선택된 날짜 표시
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: _buildScheduleList(), // 일정 목록 출력
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: '일정 추가하기', // 버튼에 표시할 텍스트
              onPressed: () => _addSchedule(
                  _focusedDay), // travelPlan은 widget.travelPlan으로 참조
            ),
          ),
        ],
      ),
    );
  }

  // 일정 목록 빌드
  Widget _buildScheduleList() {
    List<Schedule> schedulesForSelectedDate = _schedules
        .where((schedule) => isSameDay(schedule.dateTime, _selectedDate))
        .toList();

    if (schedulesForSelectedDate.isEmpty) {
      return const Center(
        child: Text('일정을 추가해주세요', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: schedulesForSelectedDate.length,
      itemBuilder: (context, index) {
        final schedule = schedulesForSelectedDate[index];
        return _buildHoverableScheduleCard(schedule); // 마우스 호버 기능 추가
      },
    );
  }

  // 일정 카드에 마우스 호버 시 배경색 변화 추가
  Widget _buildHoverableScheduleCard(Schedule schedule) {
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) {
            setState(() {
              isHovered = true; // 마우스가 카드 위에 있을 때
            });
          },
          onExit: (_) {
            setState(() {
              isHovered = false; // 마우스가 카드에서 벗어났을 때
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color:
                  isHovered ? Colors.grey.shade300 : Colors.white, // 호버 시 색상 변화
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // 내용 부분
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 시간 텍스트
                      Text(
                        '오후 ${schedule.dateTime.hour}:${schedule.dateTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 제목 텍스트 (한 줄까지만 표시, 넘으면 "..." 처리)
                      Text(
                        schedule.title,
                        maxLines: 1, // 한 줄까지만 표시
                        overflow: TextOverflow.ellipsis, // 넘치면 "..." 표시
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // 메모 텍스트 (세 줄까지만 표시, 넘으면 "..." 처리)
                      Text(
                        schedule.memo,
                        maxLines: 3, // 최대 3줄까지만 표시
                        overflow: TextOverflow.ellipsis, // 넘치면 "..." 표시
                        softWrap: true, // 줄바꿈 허용
                      ),
                    ],
                  ),
                ),
                // 수정 버튼
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black), // 수정 버튼
                  onPressed: () => _editSchedule(schedule), // 스케줄 전달
                ),
                // 삭제 버튼
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, schedule),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
