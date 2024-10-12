import 'package:flutter/material.dart';
import 'package:travelplanner/travle_plan/pages/travel_plan_list_page.dart';
import 'package:travelplanner/main/pages/home.dart';
import 'package:travelplanner/travle_plan/pages/travel_plan_add_page.dart'; // 여행 추가 페이지 추가

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 1; // 홈 페이지를 기본값으로 설정

  // 네비게이션할 페이지 리스트 정의
  List<Widget> _pages = [
    TravelPlanListPage(), // 일정 페이지
    Home(),               // 홈 페이지
    TravelPlanAddPage(),  // 여행 추가 페이지
  ];

  void _onItemTapped(int index) {
    if (index < _pages.length) { // 인덱스가 _pages 리스트 범위 내인지 확인
      setState(() {
        _selectedIndex = index;
      });
    }
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
          height: 90, // 높이를 90으로 설정
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              // 첫 번째 탭: 일정 페이지
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_today,
                  size: 30,
                  color: _selectedIndex == 0 ? Colors.black : Colors.grey,
                ),
                label: '여행 목록',
              ),
              // 두 번째 탭: 홈 페이지
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: _selectedIndex == 1 ? Colors.black : Colors.grey,
                ),
                label: 'Home',
              ),
              // 세 번째 탭: 여행 추가 페이지
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.note_add,
                  size: 30,
                  color: _selectedIndex == 2 ? Colors.black : Colors.grey,
                ),
                label: '여행 추가',
              ),
            ],
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontSize: 14),
            unselectedLabelStyle: TextStyle(fontSize: 14),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}