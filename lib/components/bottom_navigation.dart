import 'package:flutter/material.dart';
import 'package:slicing_1/screen/anime_list/list_anime.dart';
import 'package:slicing_1/screen/chat_list/chat_list.dart';
import 'package:slicing_1/screen/profile_screen/profile_screen.dart';

class BottomNavigation extends StatefulWidget {
    final bool isLoggedIn;
  const BottomNavigation({super.key, required this.isLoggedIn});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    ListAnime(),
    ChatList(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats'
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          )
        ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
      ),
    );
  }
}