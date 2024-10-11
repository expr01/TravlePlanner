import 'package:flutter/material.dart';
import '../models/schedule.dart';

class AddSchedulePage extends StatefulWidget {
  final DateTime selectedDate;

  const AddSchedulePage({super.key, required this.selectedDate});

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
    _selectedDateTime = widget.selectedDate;
  }

  // 날짜 및 시간 선택
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

    // 제목과 날짜가 설정된 경우에만 저장
    final schedule = Schedule(
      title: _titleController.text,
      dateTime: _selectedDateTime!, // 필수 입력이므로 null이 아님
      memo: _memoController.text, // 내용은 null 허용
    );

    Navigator.pop(context, schedule);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration:
                  const InputDecoration(labelText: '제목'), // 'Title' -> '제목'
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDateTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '날짜 및 시간 설정', // 날짜 설정 안내 텍스트
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedDateTime != null
                          ? '${_selectedDateTime!.year}년 ${_selectedDateTime!.month}월 ${_selectedDateTime!.day}일 ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}'
                          : '날짜/시간을 선택해주세요', // 선택된 날짜 및 시간이 없으면 안내 메시지 표시
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _memoController,
              decoration:
                  const InputDecoration(labelText: '내용'), // 'Memo' -> '내용'
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _onSave,
              child: const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
