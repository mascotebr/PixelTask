import 'package:flutter/material.dart';
import 'package:pixel_tasks/model/achievements.dart';
import '../utils/bodys_util.dart';
import '../utils/char_util.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key, this.title});
  // ignore: prefer_typing_uninitialized_variables
  final title;
  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  Achievements selected = Achievements();

  @override
  Widget build(BuildContext context) {
    return BodysUtil.bodyResponsiveHome(
        context,
        Scaffold(
          backgroundColor: const Color(0xff3B4254),
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: const Color.fromARGB(255, 38, 44, 58),
          ),
          body: medals(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: selected.description != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
                        color: Color.fromARGB(255, 38, 44, 58),
                      ),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              selected = Achievements();
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    ),
                    Container(
                      constraints:
                          const BoxConstraints(minHeight: 150, maxHeight: 400),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
                        color: Color.fromARGB(255, 38, 44, 58),
                      ),
                      width: MediaQuery.of(context).size.width * 0.95,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        selected.description!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                )
              : Container(),
        ),

        //Windows

        Scaffold(
            backgroundColor: const Color(0xff3B4254),
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Row(
              children: [
                BodysUtil.navegationDesktop(context, 0),
                medals(),
              ],
            )));
  }

  Widget medals() {
    int medals = CharUtil.achievements.length;
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(16.0),
      children: [
        for (int i = 0; i < medals; i++)
          InkWell(
            child: cardMedal(CharUtil.achievements[i]),
            onTap: () {
              setState(() {
                selected = CharUtil.achievements[i];
              });
            },
          ),
      ],
    );
  }

  Widget cardMedal(Achievements achievement) {
    return Card(color: const Color(0xff424C5E), child: medal(achievement));
  }

  Widget medal(Achievements achievement) {
    switch (achievement.medal) {
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/medals/medal1.png',
            ),
            Text(
              achievement.name1!,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/medals/medal2.png',
            ),
            Text(
              achievement.name2!,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );

      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/medals/medal3.png',
            ),
            Text(
              achievement.name3!,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Opacity(
            opacity: 0.5,
            child: Image.asset(
              'images/medals/nomedal.png',
            )),
      ],
    );
  }
}
