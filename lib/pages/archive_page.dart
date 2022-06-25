import 'package:flutter/material.dart';
import 'package:pixel_tasks/utils/bodys_util.dart';

import '../model/task.dart';
import '../utils/navigation_util.dart';
import '../utils/task_util.dart';
import '../widgets/card_task.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  void initState() {
    readAllTasks();

    super.initState();
  }

  List<Task> tasksFinished = <Task>[];

  Future<void> readAllTasks() async {
    List<Task> tasks = await TaskUtil.readTasksFinished();
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].isDairy) {
        int repeat = tasks.where((t) => t.key == tasks[i].key).length;
        tasks[i].repeat = repeat;
        tasksFinished.add(tasks[i]);
        tasks.removeWhere((t) => t.key == tasks[i].key);
      } else {
        tasksFinished.add(tasks[i]);
      }
    }
    setState(() {});
  }

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
            body: tasksFinished.isNotEmpty
                ? ListView.builder(
                    itemCount: tasksFinished.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardTask(
                        task: tasksFinished[index],
                      );
                    },
                  )
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
                BodysUtil.navegationDesktop(context, 2),
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
                        child: Column(
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
                                index < tasksFinished.length;
                                index++)
                              CardTask(task: tasksFinished[index]),
                          ],
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
