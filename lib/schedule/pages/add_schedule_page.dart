import 'package:flutter/material.dart';
import 'package:travelplanner/travle_plan/models/travel_plan.dart';
import '../models/schedule.dart';

class AddSchedulePage extends StatefulWidget {
  final DateTime selectedDate;
  final TravelPlan travelPlan; // TravelPlan을 전달받음
  final Schedule? schedule; // 수정할 스케줄 (null일 경우 신규 생성)

  const AddSchedulePage({
    super.key,
    required this.selectedDate,
    required this.travelPlan, // TravelPlan 필요
    this.schedule,
  });

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.schedule?.dateTime ?? widget.selectedDate;

    // 수정 모드일 경우, 기존 데이터로 채움
    if (widget.schedule != null) {
      _titleController.text = widget.schedule!.title;
      _memoController.text = widget.schedule!.memo;
    }
  }

  // DateTime 선택 함수
  void _selectDateTime(BuildContext context) async {
    final DateTime startDate =
        widget.travelPlan.startDate; // TravelPlan의 startDate
    final DateTime endDate = widget.travelPlan.endDate; // TravelPlan의 endDate

    DateTime initialDate = _selectedDateTime ?? startDate;

    // 만약 initialDate가 lastDate(종료 날짜)보다 이후일 경우, lastDate로 설정
    if (initialDate.isAfter(endDate)) {
      initialDate = endDate;
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate, // 수정된 initialDate 사용
      firstDate: startDate, // 여행 시작 날짜
      lastDate: endDate, // 여행 종료 날짜
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // 저장 버튼을 눌렀을 때
  void _onSave() {
    if (_titleController.text.isEmpty) {
      _showAlertDialog(context, '제목을 입력해주세요.');
      return;
    }

    if (_selectedDateTime == null) {
      _showAlertDialog(context, '날짜 및 시간을 설정해주세요.');
      return;
    }

    final schedule = Schedule(
      title: _titleController.text,
      dateTime: _selectedDateTime!,
      memo: _memoController.text,
    );

    Navigator.pop(context, schedule); // 수정된 스케줄을 반환
  }

  // 경고 다이얼로그
  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('입력 오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.schedule == null ? '일정 추가' : '일정 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 제목 입력
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // 날짜 및 시간 설정
            GestureDetector(
              onTap: () => _selectDateTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '날짜 및 시간 설정',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedDateTime != null
                          ? '${_selectedDateTime!.year}년 ${_selectedDateTime!.month}월 ${_selectedDateTime!.day}일 ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                          : '날짜/시간을 선택해주세요',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 내용 입력
            TextField(
              controller: _memoController,
              maxLength: 300,
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _onSave,
              child: Text(widget.schedule == null ? '저장' : '수정'),
            ),
          ],
        ),
      ),
    );
  }
}
