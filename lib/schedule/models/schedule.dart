class Schedule {
  final String title;
  final DateTime dateTime;
  final String memo;

  Schedule({
    required this.title,
    required this.dateTime,
    required this.memo,
  });

  // 일정 데이터를 Map으로 변환하여 SharedPreferences에 저장
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'memo': memo,
    };
  }

  // Map 데이터를 일정으로 변환하여 SharedPreferences에서 불러오기
  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      title: map['title'],
      dateTime: DateTime.parse(map['dateTime']),
      memo: map['memo'],
    );
  }
}
