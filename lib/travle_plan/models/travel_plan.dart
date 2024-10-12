// travel_plan.dart
class TravelPlan {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String destination;
  final String memo;

  TravelPlan({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.destination,
    required this.memo,
  });

  // JSON 변환 메서드 추가 (저장 및 로드 시 필요)
  Map<String, dynamic> toJson() {
    return {
      'id': id, // auto_increment
      'title': title, // 제목
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'destination': destination, // 국가
      'memo': memo, // 내용
    };
  }

  factory TravelPlan.fromJson(Map<String, dynamic> json) {
    return TravelPlan(
      id: json['id'],
      title: json['title'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      destination: json['destination'],
      memo: json['memo'],
    );
  }
}
