import 'package:flutter/material.dart';
import 'package:pixel_tasks/services/char_repository.dart';
import 'package:pixel_tasks/services/task_finished_repository.dart';
import 'package:pixel_tasks/utils/bodys_util.dart';
import 'package:provider/provider.dart';

import '../utils/navigation_util.dart';
import '../widgets/card_task.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  late TaskFinishedRepository tasksFinished;
  late CharRepository char;

  @override
  Widget build(BuildContext context) {
    tasksFinished = context.watch<TaskFinishedRepository>();
    char = context.watch<CharRepository>();

    return BodysUtil.bodyResponsiveHome(
        context,
        Scaffold(
            backgroundColor: const Color(0xff3B4254),
            appBar: AppBar(
              title: const Text("Completed Tasks"),
              backgroundColor: const Color.fromARGB(255, 38, 44, 58),
            ),
            body: tasksFinished.list.isNotEmpty
                ? Consumer<TaskFinishedRepository>(
                    builder: (context, tfs, child) {
                    return ListView.builder(
                      itemCount: tfs.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CardTask(
                          task: tfs.list[index],
                        );
                      },
                    );
                  })
                : const Center(
                    child: Text(
                    'No tasks here :(',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  )),
            bottomNavigationBar: NavigationUtil.bottomNavigator(2, context)),

        //Windows

        Scaffold(
            backgroundColor: const Color(0xff3B4254),
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Row(
              children: [
                BodysUtil.navegationDesktop(
                    context,
                    2,
                    char.pixelChar(
                        context, MediaQuery.of(context).size.width * 0.8, 0.2)),
                Container(
                  margin: const EdgeInsets.only(
                    left: 8.0,
                    top: 16.0,
                  ),
                  width: MediaQuery.of(context).size.width * 0.8 - 8.0,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                    ),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, top: 16.0),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24.0, bottom: 16.0, left: 16.0),
                        child: Consumer<TaskFinishedRepository>(
                          builder: (context, tfs, child) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 16.0),
                                  child: Text(
                                    "Completed Tasks",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                for (int index = 0;
                                    index < tfs.list.length;
                                    index++)
                                  CardTask(task: tfs.list[index]),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  Widget divider() {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              color: const Color(0xff424C5E),
              height: 3,
              width: MediaQuery.of(context).size.width * 0.42,
            ),
            const Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_circle_down,
                color: Color(0xff424C5E),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                color: const Color(0xff424C5E),
                height: 3,
                width: MediaQuery.of(context).size.width * 0.42,
              ),
            ),
          ],
        ));
  }
}
