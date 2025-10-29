
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:special_education/screen/dashboard/dashboard_view.dart';
import 'package:special_education/screen/student/student_dashboard_view.dart';
import 'package:special_education/screen/teacher/teacher_dashboard_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardView(),
    StudentDashboard(),
    TeacherDashboard(),
    Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.dashboard_outlined, title: 'Dashboard'),
          TabItem(icon: Icons.person_3_rounded, title: 'Student'),
          TabItem(icon: Icons.group, title: 'Teacher'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.pinkAccent,
        activeColor: Colors.white,
        color: Colors.white70,
      ),
    );
  }
}