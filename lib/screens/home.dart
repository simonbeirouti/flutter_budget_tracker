import 'package:flutter/material.dart';
import 'package:budget_tracker/pages/home_page.dart';
import 'package:budget_tracker/pages/profile_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List for the bottom nav bar
  List<BottomNavigationBarItem> bottomNavItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  // Load the pages based on the button you click
  List<Widget> pages = const [
    HomePage(),
    ProfilePage(),
  ];

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        // Add an icon to the appbar
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_money),
            onPressed: () {
              // Dialog to add budget
              showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog();
                },
              );
            },
          ),
        ],
      ),
      // Changes the index based on which page you click
      body: pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        // Load the items from the List above
        items: bottomNavItems,
        onTap: (index) {
          // Change state to the page that you click on
          setState(() {
            _currentPageIndex = index;
          });
        },
      ),
    );
  }
}
