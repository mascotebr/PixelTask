import 'package:flutter/material.dart';
import 'package:pixel_tasks/utils/char_util.dart';
import 'package:pixel_tasks/utils/help_util.dart';
import 'package:pixel_tasks/utils/navigation_util.dart';
import 'package:pixel_tasks/widgets/card_task.dart';
import 'package:pixel_tasks/widgets/dialog_task.dart';
import 'package:pixel_tasks/widgets/silver_pixel.dart';
import '../model/char.dart';
import '../model/task.dart';
import '../utils/task_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    readAllTasks();

    super.initState();
  }

  List<Task> tasks = <Task>[];
  List<Task> tasksDaily = <Task>[];
  List<Task> tasksNotDaily = <Task>[];
  List<Task> tasksFinished = <Task>[];
  Char char = Char();

  Future<void> _onCreateTask(Task task) async {
    await TaskUtil.writeTask(task);
    await readAllTasks();
    setState(() {});
  }

  Future<void> _onFinishTask(Task task) async {
    await TaskUtil.writeTaskFinish(task);
    await readAllTasks();
    setState(() {});
  }

  Future<void> readAllTasks() async {
    char = await CharUtil.setChar();

    tasks = await TaskUtil.readTasks();
    tasksNotDaily = tasks.where((t) => !t.isDairy).toList();
    tasksDaily = tasks.where((t) => t.isDairy).toList();

    tasks = <Task>[];
    tasks.addAll(tasksDaily);
    tasks.addAll(tasksNotDaily);

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
        body: CustomScrollView(
          slivers: [
            SilverPixel(char: char),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListBody(
                  children: [
                    if (index == 0)
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 24.0, bottom: 16.0, left: 16.0),
                        child: Text(
                          "My Tasks",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    if (tasks.isNotEmpty &&
                        HelpUtil.isToday(tasks[index].lastFinish) &&
                        tasks[index].isDairy)
                      cardDismissible(tasks[index]),
                    if (tasks.isNotEmpty &&
                        !HelpUtil.isToday(tasks[index].lastFinish) &&
                        tasks[index].isDairy)
                      card(tasks[index]),
                    if (tasks.isNotEmpty && index == tasksDaily.length)
                      divider(),
                    if (tasks.isNotEmpty && !tasks[index].isDairy)
                      cardDismissible(tasks[index]),
                    if (index == tasks.length - 1) const SizedBox(height: 100),
                  ],
                );
              },
              childCount: tasks.isEmpty ? 1 : tasks.length,
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialogTask(context, _onCreateTask),
          tooltip: 'New Task',
          backgroundColor: Color(char.color),
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: NavigationUtil.bottomNavigator(1, context));
  }

  Widget cardDismissible(Task task) {
    return Dismissible(
      key: Key(task.key),
      background: Container(
        color: const Color(0xff3B4254),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.withOpacity(0.8),
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
      onDismissed: (DismissDirection duration) {
        _onFinishTask(task);
      },
      child: CardTask(
        task: task,
      ),
    );
  }

  Widget card(Task task) {
    return CardTask(
      task: task,
    );
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
