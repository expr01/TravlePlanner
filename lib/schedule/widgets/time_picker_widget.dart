import 'package:flutter/material.dart';
import '../widgets/custom_button.dart'; // 커스텀 버튼 임포트

class TimePickerWidget extends StatelessWidget {
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerWidget({super.key, required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: '시간 선택하기', // 버튼에 표시할 텍스트
      onPressed: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 9, minute: 0),
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
    );
  }
}
