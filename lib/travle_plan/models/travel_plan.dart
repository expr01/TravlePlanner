// domains/travel_plan/models/travel_plan.dart
class TravelPlan {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String destination;

  TravelPlan({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.destination,
  });
}
