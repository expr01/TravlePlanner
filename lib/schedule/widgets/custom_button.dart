import 'package:flutter/material.dart';

// 커스텀 버튼 위젯
class CustomButton extends StatelessWidget {
  final String text; // 버튼에 표시될 텍스트
  final VoidCallback onPressed; // 버튼을 눌렀을 때 실행되는 함수
  final bool isPrimary; // 기본 버튼인지 여부 (필요에 따라 다르게 스타일 적용 가능)

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true, // 기본값은 true
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 1, 34, 23), // 버튼 색상
        minimumSize: const Size(double.infinity, 50), // 버튼 크기 조정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 둥근 모서리
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
        ), // 텍스트 크기
      ),
    );
  }
}
