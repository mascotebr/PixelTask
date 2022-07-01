import 'package:flutter/material.dart';
import 'package:pixel_tasks/pages/achievements_page.dart';
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
              Icons.drive_file_rename_outline_rounded,
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
      selectedItemColor: Colors.white,
      unselectedItemColor: const Color(0xff3B4254),
      onTap: (index) {
        onItemTapped(index, context);
      },
    );
  }

  static Widget leftNavigator(int selectedIndex, BuildContext context) {
    return ListBody(
      children: [
        InkWell(
          child: ListTile(
            leading: const Icon(Icons.drive_file_rename_outline_rounded),
            iconColor: selectedIndex == 1
                ? Colors.white
                : Colors.black.withOpacity(0.75),
            minLeadingWidth: 16,
            title: Text(
              "My tasks",
              style: TextStyle(
                  color: selectedIndex == 1
                      ? Colors.white
                      : Colors.black.withOpacity(0.75)),
            ),
          ),
          onTap: () {
            onItemTapped(1, context);
          },
        ),
        InkWell(
          child: ListTile(
            leading: const Icon(Icons.person),
            iconColor: selectedIndex == 0
                ? Colors.white
                : Colors.black.withOpacity(0.75),
            minLeadingWidth: 16,
            title: Text(
              "My Char",
              style: TextStyle(
                  color: selectedIndex == 0
                      ? Colors.white
                      : Colors.black.withOpacity(0.75)),
            ),
          ),
          onTap: () {
            onItemTapped(0, context);
          },
        ),
        InkWell(
          child: ListTile(
            leading: const Icon(Icons.archive),
            iconColor: selectedIndex == 2
                ? Colors.white
                : Colors.black.withOpacity(0.75),
            minLeadingWidth: 16,
            title: Text(
              "Completed Tasks",
              style: TextStyle(
                  color: selectedIndex == 2
                      ? Colors.white
                      : Colors.black.withOpacity(0.75)),
            ),
          ),
          onTap: () {
            onItemTapped(2, context);
          },
        ),
        InkWell(
          child: ListTile(
            leading: Image.asset(
              "images/medals/medal1.png",
              scale: 2.5,
            ),
            iconColor: selectedIndex == 3
                ? Colors.white
                : Colors.black.withOpacity(0.75),
            minLeadingWidth: 16,
            title: Text(
              "Achievements",
              style: TextStyle(
                  color: selectedIndex == 3
                      ? Colors.white
                      : Colors.black.withOpacity(0.75)),
            ),
          ),
          onTap: () {
            onItemTapped(3, context);
          },
        ),
      ],
    );
  }

  static void onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => const PixelCharPage(
              title: 'Pixel Char',
            ),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => const HomePage(
              title: 'Pixel Tasks',
            ),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => const ArchivePage(
              title: 'Completed Tasks',
            ),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => const AchievementsPage(
              title: 'Achievements',
            ),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
        break;
    }
  }
}
