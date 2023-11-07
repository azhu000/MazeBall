import 'package:flutter/material.dart';
import 'package:myapp/ballMaze.dart';
import 'package:myapp/home_page.dart';
import 'package:myapp/maze.dart';
import 'package:myapp/mazeimage.dart';
import 'package:myapp/newball.dart';
import 'package:myapp/pages/userHome.dart';
import 'package:myapp/pages/userSearch.dart';
import 'package:myapp/pages/userSettings.dart';
import 'package:myapp/ball.dart';
import "test.dart";

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavBarState();
}

//Functionality of the Nav Bar
class _NavBarState extends State<Navbar> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //Different pages of the Nav Bar
  final List<Widget> _pages = [
    HomePage(),
    //UserHome(),
    UserSearch(),
    UserSettings(),
    BallGyro(),
    // MazeApp()
    newBall(),
    SensorDataWidget(),
    ballMaze(),
    mazeImage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _navigateBottomBar,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Settings'),
              BottomNavigationBarItem(icon: Icon(Icons.circle), label: "Ball"),
              // BottomNavigationBarItem(
              // icon: Icon(Icons.question_mark_sharp), label: "Maze"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.question_mark_sharp), label: "Ball2"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.question_mark_sharp), label: "test"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.circle_sharp), label: "BallMaze"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.circle_sharp), label: "Maze Image"),
            ]));
  }
}
