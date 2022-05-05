import 'package:flutter/material.dart';
import 'PanierPage.dart';
import 'ProfilePage.dart';
import 'BoutiquePage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> navigationPages = [
    BoutiquePage(),
    PanierPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.storefront_outlined,
            ),
            label: 'Boutique',
            activeIcon: Icon(Icons.storefront_rounded),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Panier',
            activeIcon: Icon(Icons.shopping_basket),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
            activeIcon: Icon(
              Icons.person,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: navigationPages[_selectedIndex],
    );
  }
}
