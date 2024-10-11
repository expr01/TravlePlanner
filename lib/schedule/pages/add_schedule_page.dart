import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../widgets/custom_button.dart';

class AddSchedulePage extends StatefulWidget {
  final DateTime selectedDate;
  final Schedule? schedule; // 수정할 스케줄 (null일 경우 신규 생성)

  const AddSchedulePage({super.key, required this.selectedDate, this.schedule});

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

  void _selectDateTime(BuildContext context) async {
    final DateTime startDate = DateTime(2023, 1, 24); // 여행 시작 날짜
    final DateTime endDate = DateTime(2023, 1, 27); // 여행 종료 날짜

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime!,
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

  // 경고 다이얼로그
  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('입력 오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
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

    // 제목과 날짜가 설정된 경우에만 저장 또는 수정
    final schedule = Schedule(
      title: _titleController.text,
      dateTime: _selectedDateTime!,
      memo: _memoController.text,
    );

    Navigator.pop(context, schedule); // 수정된 스케줄을 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E6E1), // 배경색 설정
      appBar: AppBar(
        title: Text(widget.schedule == null ? '일정 추가' : '일정 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 제목 입력 박스
            TextField(
              controller: _titleController,
              maxLength: 50, // 제목 글자 수 제한
              decoration: const InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
                counterText: '', // 글자 수 카운터 숨기기
              ),
            ),
            const SizedBox(height: 20),
            // 날짜 및 시간 설정 텍스트
            const Text(
              '날짜 및 시간 설정', // 텍스트를 박스 위에 위치
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // 텍스트와 박스 간 간격 추가

            // 날짜 및 시간 설정 박스
            GestureDetector(
              onTap: () => _selectDateTime(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      _selectedDateTime != null
                          ? '${_selectedDateTime!.year}년 ${_selectedDateTime!.month}월 ${_selectedDateTime!.day}일 ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}'
                          : '날짜/시간을 선택해주세요',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 내용 입력 박스
            TextField(
              controller: _memoController,
              maxLength: 300, // 내용 글자 수 제한
              decoration: const InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
                counterText: '', // 글자 수 카운터 숨기기
              ),
              maxLines: 10,
            ),
            const Spacer(),

            // 저장 또는 수정 버튼
            CustomButton(
              text: widget.schedule == null ? '저장' : '수정', // '저장' 또는 '수정' 텍스트
              onPressed: _onSave, // 저장 또는 수정 로직
            ),
          ],
        ),
      ),
    );
  }
}
