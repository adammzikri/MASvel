// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:masvel/screens/categories.dart';
import 'package:masvel/screens/home_screens.dart';
import 'package:masvel/screens/nearMe.dart';
import 'package:masvel/screens/plan_travel.dart';
import 'package:masvel/screens/user.dart';
import 'package:masvel/screens/wishlist.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {'page': const HomeScreen(), 'title': 'Home'},
    {
      'page': TravelPlannerScreen(),
      'title': 'Travel Planner',
    },
    {'page': NearScreen(), 'title': 'Near Me'},
    {'page': const WishlistScreen(), 'title': 'Wishlist'},
    {'page': const UserScreen(), 'title': 'Profile'},
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndex]['title']),
        automaticallyImplyLeading: false,
      ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _selectedPage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.category),
            label: "Travel Planner",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.location),
            label: "Near Me",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.heart),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.user2),
            label: "User",
          ),
        ],
      ),
    );
  }
}
