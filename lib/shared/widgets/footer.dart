import 'package:flutter/material.dart';
import 'package:travleplanner/main/pages/add_travel_page.dart';
import 'package:travleplanner/main/pages/travel_list_page.dart';
import 'package:travleplanner/main/pages/travel_detail_page.dart'; // 여행 상세 페이지 import

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 1; // 홈 페이지를 기본값으로 설정

  // 네비게이션할 페이지 리스트 정의
  List<Widget> _pages = [
    TravelDetailPage(), // 일정 페이지
    TravelListPage(),   // 홈 페이지
    AddTravelPage(),    // 여행 추가 페이지
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // 선택된 페이지 표시
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0), // 왼쪽 상단 둥글게
          topRight: Radius.circular(15.0), // 오른쪽 상단 둥글게
        ),
        child: Container(
          height: 90, // 높이를 90으로 설정 (필요에 따라 조정)
          child: BottomNavigationBar(
            backgroundColor: Colors.white, // 배경 색상 설정
            currentIndex: _selectedIndex,  // 현재 선택된 인덱스
            onTap: _onItemTapped,          // 탭 선택 시 페이지 전환
            items: [
              // 첫 번째 탭: 일정 페이지
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_today,
                  size: 30, // 아이콘 크기를 키움
                  color: _selectedIndex == 0 ? Colors.black : Colors.grey,
                ),
                label: '일정',
              ),
              // 두 번째 탭: 홈 페이지
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30, // 아이콘 크기를 키움
                  color: _selectedIndex == 1 ? Colors.black : Colors.grey,
                ),
                label: 'home',
              ),
              // 세 번째 탭: 여행 추가 페이지
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.note_add,
                  size: 30, // 아이콘 크기를 키움
                  color: _selectedIndex == 2 ? Colors.black : Colors.grey,
                ),
                label: '여행',
              ),
            ],
            selectedItemColor: Colors.black,  // 선택된 항목 색상
            unselectedItemColor: Colors.grey, // 선택되지 않은 항목 색상
            selectedLabelStyle: TextStyle(fontSize: 14),  // 선택된 라벨 스타일
            unselectedLabelStyle: TextStyle(fontSize: 14), // 선택되지 않은 라벨 스타일
            showUnselectedLabels: true, // 선택되지 않은 라벨도 표시
            type: BottomNavigationBarType.fixed, // 모든 항목 고정
          ),
        ),
      ),
    );
  }
}
