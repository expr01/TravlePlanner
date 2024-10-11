import 'package:flutter/material.dart';
import 'package:travelplanner/shared/widgets/footer.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 페이지'),
        backgroundColor: Colors.blue, // 임시 설정, 필요에 따라 수정
      ),
      body: const Center(
        child: Text(
          '메인 콘텐츠가 여기에 표시됩니다.',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(), // bottomNavigationBar 속성에 추가
    );
  }
}
