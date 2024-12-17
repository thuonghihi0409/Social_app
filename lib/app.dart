import 'package:flutter/material.dart';
import 'package:social_app/social/view/image_screen.dart';
import 'package:social_app/social/view/post_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomeScreen(),
      );
    
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeSreeenState();
}

class _HomeSreeenState extends State<HomeScreen> {
  int _selectedIndex = 0; 
  final List<Widget> _screens = [
    PostScreen(),
    ImageScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex, 
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items:  [
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo, color: Colors.white),
            label: '',
          ),
        ],
      ),
    );
  }
}