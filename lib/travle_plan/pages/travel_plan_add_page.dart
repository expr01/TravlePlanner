// travel_plan_add_page.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/travel_plan.dart';
import '../services/travel_plan_service.dart';

class TravelPlanAddPage extends StatefulWidget {
  @override
  _TravelPlanAddPageState createState() => _TravelPlanAddPageState();
}

class _TravelPlanAddPageState extends State<TravelPlanAddPage> {
  final TravelPlanService _travelPlanService = TravelPlanService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  // 여행 날짜 선택
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
        _dateController.text =
        '${_startDate!.year}년 ${_startDate!.month}월 ${_startDate!.day}일 - ${_endDate!.year}년 ${_endDate!.month}월 ${_endDate!.day}일';
      });
    }
  }

  // 여행 나라 선택
  Future<void> _selectCountry(BuildContext context) async {
    final List<String> countries = [
      '가나', '가봉', '가이아나', '감비아', '건지', '과들루프', '과테말라', '괌', '그레나다'
    ];
    String? selected = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(countries[index]),
                onTap: () {
                  Navigator.pop(context, countries[index]);
                },
              );
            },
          ),
        );
      },
    );

    if (selected != null && selected != _countryController.text) {
      setState(() {
        _countryController.text = selected;
      });
    }
  }

  // 여행 계획 저장
  Future<void> _saveTravelPlan() async {
    if (_startDate != null &&
        _endDate != null &&
        _titleController.text.isNotEmpty &&
        _countryController.text.isNotEmpty) {
      final String id = Uuid().v4(); // 고유 ID 생성
      final String title = _titleController.text;
      final String memo = _memoController.text;
      final String destination = _countryController.text;

      // 새로운 TravelPlan 객체 생성
      TravelPlan newPlan = TravelPlan(
        id: id,
        title: title,
        startDate: _startDate!,
        endDate: _endDate!,
        destination: destination,
        memo: memo,
      );

      // 로컬 저장소에 추가
      await _travelPlanService.addTravelPlan(newPlan);

      // 저장 후 목록 페이지로 리디렉션
      Navigator.popAndPushNamed(context, '/list');
    } else {
      // 필수 입력 값이 없을 경우 경고 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여행 계획 추가하기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '여행 제목'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDateRange(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(labelText: '여행 날짜', hintText: '날짜를 선택해 주세요'),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectCountry(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _countryController,
                  decoration: InputDecoration(labelText: '여행 나라', hintText: '나라를 선택해 주세요'),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _memoController,
              maxLines: 5,
              decoration: InputDecoration(labelText: '메모'),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _saveTravelPlan,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}