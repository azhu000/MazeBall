import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavBarState();
}

//Different pages of the Nav Bar
final List<Widget> _pages = [
  Center(
    child: Text(
      'Home Page',
      style: TextStyle(fontSize: 50),
    ),
  ),
  Center(
    child: Text(
      'Home Page',
      style: TextStyle(fontSize: 50),
    ),
  ),
  Center(
    child: Text(
      'Home Page',
      style: TextStyle(fontSize: 50),
    ),
  ),
];

//Functionality of the Nav Bar
class _NavBarState extends State<Navbar>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: 
        Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              onTabChange: (index) {
                print(index);
              },
              padding: EdgeInsets.all(16),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'Search',
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Settings',
                  ),
                ],
            ),
          ),
        ),
    );
  }

}