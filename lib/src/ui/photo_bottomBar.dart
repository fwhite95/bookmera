import 'package:flutter/material.dart';

Widget photoBottomBar(dynamic onTabTapped) {
  return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
            ),
          ],
        ),
        child: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        onTap: onTabTapped, //Calls to function for navigation
        items: [
          
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Bookshelves',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
      );
}