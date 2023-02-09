import 'package:flutter/material.dart';
import 'package:pixel_tasks/pages/achievements_page.dart';
import 'package:pixel_tasks/pages/home_page.dart';
import 'package:pixel_tasks/pages/pixel_char_page.dart';
import 'package:pixel_tasks/services/page_service.dart';
import 'package:provider/provider.dart';

import '../services/char_repository.dart';
import '../utils/design_util.dart';
import '../utils/navigation_util.dart';

class PageViewPage extends StatefulWidget {
  const PageViewPage({super.key});

  @override
  State<PageViewPage> createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage> {
  PageController controller = PageController();
  late PageService pages;
  late CharRepository char;

  @override
  Widget build(BuildContext context) {
    char = context.watch<CharRepository>();
    pages = context.watch<PageService>();

    final PageView pageView = PageView(
      onPageChanged: (value) => pages.setPage(value),
      controller: controller,
      children: const [HomePage(), PixelCharPage(), AchievementsPage()],
    );
    return Scaffold(
        backgroundColor: DesignUtil.darkGray,
        appBar: AppBar(
          title: const Text("Pixel Tasks"),
          backgroundColor: DesignUtil.darkGray,
          toolbarHeight: 0,
        ),
        body: Stack(
          children: [
            Container(
                height: 340.0,
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(180.0),
                      ),
                      color: Color(char.single.color).withAlpha(225),
                    ),
                    child: char.pixelChar(context, 0, 1))),
            Container(margin: const EdgeInsets.only(top: 365), child: pageView),
          ],
        ),
        bottomNavigationBar:
            NavigationUtil.bottomNavigator(context, controller, pages));
  }
}
