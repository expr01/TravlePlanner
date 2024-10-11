import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerWidget({super.key, required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 9, minute: 0),
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      child: const Text('시간 선택하기'),
    );
  }
}
