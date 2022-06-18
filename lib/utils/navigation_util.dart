import 'package:flutter/material.dart';
import 'package:pixel_tasks/pages/archive_page.dart';
import 'package:pixel_tasks/pages/home_page.dart';
import 'package:pixel_tasks/pages/pixel_char_page.dart';

class NavigationUtil {
  static Widget bottomNavigator(int selectedIndex, BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 38, 44, 58),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 28,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 28,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.archive,
              size: 28,
            ),
            label: ""),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color(0xff3B4254),
      onTap: (index) {
        onItemTapped(index, context);
      },
    );
  }

  static void onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const PixelCharPage(
              title: 'Pixel Char',
            ),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomePage(
              title: 'Pixel Tasks',
            ),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const ArchivePage(
              title: 'Finished Tasks',
            ),
          ),
        );
        break;
    }
  }
}
