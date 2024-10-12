import 'package:flutter/material.dart';
import 'package:travelplanner/schedule/pages/schedule_list_page.dart';
import '../models/travel_plan.dart';
import '../services/travel_plan_service.dart';

class TravelPlanListPage extends StatefulWidget {
  const TravelPlanListPage({super.key});

  @override
  _TravelPlanListPageState createState() => _TravelPlanListPageState();
}

class _TravelPlanListPageState extends State<TravelPlanListPage> {
  final TravelPlanService _travelPlanService = TravelPlanService();
  List<TravelPlan> _travelPlans = [];

  @override
  void initState() {
    super.initState();
    _loadTravelPlans();
  }

  Future<void> _loadTravelPlans() async {
    List<TravelPlan> plans = await _travelPlanService.getTravelPlans();
    setState(() {
      _travelPlans = plans;
    });
  }

  // 여행 계획 삭제
  Future<void> _deleteTravelPlan(String id) async {
    await _travelPlanService.removeTravelPlan(id);
    _loadTravelPlans(); // 삭제 후 목록 갱신
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 목록'),
      ),
      body: _travelPlans.isEmpty
          ? const Center(
              child: Text(
                '여행 계획이 없습니다.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _travelPlans.length,
              itemBuilder: (context, index) {
                final plan = _travelPlans[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      plan.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Text(
                          '${plan.startDate.year}년 ${plan.startDate.month}월 ${plan.startDate.day}일 - ${plan.endDate.year}년 ${plan.endDate.month}월 ${plan.endDate.day}일',
                        ),
                        const SizedBox(height: 4.0),
                        Text('목적지: ${plan.destination}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            // 삭제 버튼 눌렀을 때 여행 계획 삭제
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('삭제 확인'),
                                  content: const Text('이 여행 계획을 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('취소'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('삭제'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirm == true) {
                              _deleteTravelPlan(plan.id);
                            }
                          },
                        ),
                        const Icon(Icons.arrow_forward), // 세부 페이지 이동 아이콘
                      ],
                    ),
                    onTap: () {
                      // 여행 계획의 상세 일정 페이지로 이동 (ScheduleListPage)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScheduleListPage(
                            travelPlan: plan, // TravelPlan 객체를 전달
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) {
            _loadTravelPlans(); // 저장된 데이터 다시 불러오기
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
