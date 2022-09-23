import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pixel_tasks/pages/achievements_page.dart';
import 'package:pixel_tasks/pages/archive_page.dart';
import 'package:pixel_tasks/pages/home_page.dart';
import 'package:pixel_tasks/pages/pixel_char_page.dart';
import 'package:pixel_tasks/services/page_service.dart';

import 'design_util.dart';

class NavigationUtil {
  static Widget bottomNavigator(
      BuildContext context, PageController pageController, PageService pages) {
    return BottomNavigationBar(
      backgroundColor: DesignUtil.darkGray,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.drive_file_rename_outline_rounded,
              size: 28,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 28,
            ),
            label: ""),

        // BottomNavigationBarItem(
        //     icon: Icon(
        //       Icons.archive,
        //       size: 28,
        //     ),
        //     label: ""),
      ],
      currentIndex: pages.page,
      selectedItemColor: Colors.white,
      unselectedItemColor: DesignUtil.gray,
      onTap: (index) {
        if (index != pages.page) {
          onItemTapped(index, context, pageController);
          pages.setPage(index);
        }
      },
    );
  }

  // static Widget leftNavigator(
  //     int selectedIndex, BuildContext context, PageController? pageController) {
  //   return ListBody(
  //     children: [
  //       InkWell(
  //         child: ListTile(
  //           leading: const Icon(Icons.drive_file_rename_outline_rounded),
  //           iconColor: selectedIndex == 1
  //               ? Colors.white
  //               : Colors.black.withOpacity(0.75),
  //           minLeadingWidth: 16,
  //           title: Text(
  //             "My tasks",
  //             style: TextStyle(
  //                 color: selectedIndex == 1
  //                     ? Colors.white
  //                     : Colors.black.withOpacity(0.75)),
  //           ),
  //         ),
  //         onTap: () {
  //           onItemTapped(0, 1, context, pageController);
  //         },
  //       ),
  //       InkWell(
  //         child: ListTile(
  //           leading: const Icon(Icons.person),
  //           iconColor: selectedIndex == 0
  //               ? Colors.white
  //               : Colors.black.withOpacity(0.75),
  //           minLeadingWidth: 16,
  //           title: Text(
  //             "My Char",
  //             style: TextStyle(
  //                 color: selectedIndex == 0
  //                     ? Colors.white
  //                     : Colors.black.withOpacity(0.75)),
  //           ),
  //         ),
  //         onTap: () {
  //           onItemTapped(0, 0, context, pageController);
  //         },
  //       ),
  //       InkWell(
  //         child: ListTile(
  //           leading: const Icon(Icons.archive),
  //           iconColor: selectedIndex == 2
  //               ? Colors.white
  //               : Colors.black.withOpacity(0.75),
  //           minLeadingWidth: 16,
  //           title: Text(
  //             "Completed Tasks",
  //             style: TextStyle(
  //                 color: selectedIndex == 2
  //                     ? Colors.white
  //                     : Colors.black.withOpacity(0.75)),
  //           ),
  //         ),
  //         onTap: () {
  //           onItemTapped(0, 2, context, pageController);
  //         },
  //       ),
  //       InkWell(
  //         child: ListTile(
  //           leading: Image.asset(
  //             "images/medals/medal1.png",
  //             scale: 2.5,
  //           ),
  //           iconColor: selectedIndex == 3
  //               ? Colors.white
  //               : Colors.black.withOpacity(0.75),
  //           minLeadingWidth: 16,
  //           title: Text(
  //             "Achievements",
  //             style: TextStyle(
  //                 color: selectedIndex == 3
  //                     ? Colors.white
  //                     : Colors.black.withOpacity(0.75)),
  //           ),
  //         ),
  //         onTap: () {
  //           onItemTapped(0, 3, context, pageController);
  //         },
  //       ),
  //     ],
  //   );
  // }

  static void onItemTapped(
      int index, BuildContext context, PageController pageController) {
    if (Platform.isAndroid) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => getPage(index),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  static getPage(int index) {
    switch (index) {
      case 0:
        return const PixelCharPage();

      case 1:
        return const HomePage();

      case 2:
        return const ArchivePage();

      case 3:
        return const AchievementsPage();
    }
  }
}
