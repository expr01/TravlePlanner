import 'dart:async'; // Timer를 사용하기 위해 추가
import 'package:flutter/material.dart';

void main() => runApp(MyApp()); // const 제거

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 16.0), // 왼쪽에 16픽셀의 여백 추가
          child: Text(
            'Travelog',
            style: TextStyle(color: Colors.black), // 검은색 글씨로 설정
          ),
        ),
        backgroundColor: Colors.white, // 헤더바 배경색 흰색으로 설정
        elevation: 0, // 그림자 제거
        centerTitle: false, // 제목을 좌측에 배치
      ),
      body: ImageSlider(), // const 제거
    );
  }
}

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> images = [
    'lib/main/assets/1.jpg',
    'lib/main/assets/2.jpg',
    'lib/main/assets/3.jpg',
    'lib/main/assets/4.jpg',
    'lib/main/assets/5.jpg',
    'lib/main/assets/6.jpg',
    'lib/main/assets/7.jpg',
    'lib/main/assets/8.jpg',
    'lib/main/assets/9.jpg',
    'lib/main/assets/10.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide(); // 자동 슬라이드 시작
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 취소
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // 마지막 이미지 이후에는 첫 번째 이미지로 돌아감
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(images[index]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
