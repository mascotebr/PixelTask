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
  Achievements selected = Achievements(name: "");

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
          body: FutureBuilder(
            future: _getAchievements(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return medals();
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: selected.name != "",
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                    color: Color.fromARGB(255, 38, 44, 58),
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          selected = Achievements(name: "");
                        });
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                ),
              ),
              AnimatedContainer(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                    color: Color.fromARGB(255, 38, 44, 58),
                  ),
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: selected.name != "" ? 200 : 0,
                  padding: const EdgeInsets.only(top: 12.0),
                  duration: const Duration(seconds: 5),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          selected.name!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          "${selected.medal == 1 ? selected.description1! : selected.medal == 2 ? selected.description2 : selected.medal == 3 ? selected.description3 : ''}",
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 16),
                        ),
                      ),
                    ],
                  )),
            ],
          )),

      //Windows

      Scaffold(
        backgroundColor: const Color(0xff3B4254),
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Row(
          children: [
            BodysUtil.navegationDesktop(context, 3),
            AnimatedContainer(
              margin: const EdgeInsets.only(
                left: 8.0,
                top: 16.0,
              ),
              duration: const Duration(milliseconds: 250),
              width: selected.name != ""
                  ? MediaQuery.of(context).size.width * 0.5 - 8.0
                  : MediaQuery.of(context).size.width * 0.8 - 8.0,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                ),
                color: Colors.black.withOpacity(0.1),
              ),
              child: FutureBuilder(
                future: _getAchievements(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: medals()),
                  );
                },
              ),
            ),
            AnimatedContainer(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0)),
                  color: Color.fromARGB(255, 38, 44, 58),
                ),
                width: selected.name != ""
                    ? MediaQuery.of(context).size.width * 0.3
                    : 0,
                padding: const EdgeInsets.only(top: 12.0),
                duration: const Duration(milliseconds: 250),
                child: Stack(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            selected = Achievements(name: "");
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          selected.name!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 56.0),
                      child: Text(
                        "${selected.medal == 1 ? selected.description1! : selected.medal == 2 ? selected.description2 : selected.medal == 3 ? selected.description3 : ''}",
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 16),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget medals() {
    int medals = CharUtil.achievements.length;
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(16.0),
      children: [
        for (int i = 0; i < medals; i++) cardMedal(CharUtil.achievements[i]),
      ],
    );
  }

  Widget cardMedal(Achievements achievement) {
    return Card(color: const Color(0xff424C5E), child: medal(achievement));
  }

  Widget medal(Achievements achievement) {
    Widget child;

    switch (achievement.medal) {
      case 1:
        child = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/medals/medal1.png',
            ),
            Text(
              achievement.name!,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
        break;
      case 2:
        child = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/medals/medal2.png',
            ),
            Text(
              achievement.name!,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
        break;
      case 3:
        child = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/medals/medal3.png',
            ),
            Text(
              achievement.name!,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        );
        break;
      default:
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

    return InkWell(
        child: child,
        onTap: () {
          setState(() {
            selected = achievement;
          });
        });
  }

  Future<void> _getAchievements() async {
    await CharUtil.checkAchivements();
    return;
  }
}
