import 'package:flutter/material.dart';

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
    tasksFinished = await TaskUtil.readTasksFinished();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        bottomNavigationBar: NavigationUtil.bottomNavigator(2, context));
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
