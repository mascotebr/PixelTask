import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_tasks/model/Difficulty.dart';
import 'package:pixel_tasks/model/achievements.dart';
import 'package:pixel_tasks/utils/char_util.dart';
import 'package:pixel_tasks/utils/navigation_util.dart';
import 'package:pixel_tasks/utils/bodys_util.dart';
import 'package:pixel_tasks/widgets/card_task.dart';
import 'package:pixel_tasks/widgets/dialog_task.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../services/task_finished_repository.dart';
import '../services/task_repository.dart';
import '../utils/help_util.dart';
import '../utils/task_util.dart';
import '../widgets/dialog_achievements.dart';
import '../widgets/dialog_splash.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    readAllTasks();
    super.initState();
  }

  late TaskRepository tasks;
  late TaskFinishedRepository tasksFinished;

  TextEditingController taskController = TextEditingController(text: "");
  TextEditingController dateController = TextEditingController();

  static Task taskSelected = Task();

  final _formKey = GlobalKey<FormState>();
  final _formKeyTask = GlobalKey<FormState>();

  void _onCreateTask(Task task) {
    tasks.save(task);
  }

  Future<void> _onEditTask(Task task) async {
    tasks.save(task);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task Edited'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onFinishTask(Task task) async {
    setState(() => tasks.list.remove(task));
    double exp = 0;

    if (!task.isDaily &&
        DateTime.now().isBefore(task.date!.add(const Duration(days: 1)))) {
      exp = task.difficulty.exp / 2;
    } else {
      exp = task.difficulty.exp;
    }

    if (CharUtil.char.exp + exp >= CharUtil.maxExp) {
      showDialogLevelUp(context, exp);
    } else {
      showDialogExp(context, exp);
    }

    task.lastFinish = DateTime.now();

    if (!task.isDaily) {
      tasks.remove(task);
    }

    tasksFinished.save(task);

    CharUtil.addExp(exp);
    readAllTasks();

    if (task.isDaily) {
      await Future.delayed(const Duration(seconds: 3), () {
        tasks.save(task);
      });
    }
  }

  Future<void> _onDeleteTask(Task task) async {
    await TaskUtil.deleteTask(task);
    await readAllTasks();
    setState(() {});
  }

  Future<void> readAllTasks() async {
    await CharUtil.setChar();

    // tasksFinished = await TaskUtil.readTasksFinished();

    setState(() {});

    List<Achievements> newsAchievements = await CharUtil.checkAchivements();

    newAchievementsDialogs(newsAchievements);
  }

  Future<void> newAchievementsDialogs(
      List<Achievements> newsAchievements) async {
    if (newsAchievements.isNotEmpty) {
      for (var a in newsAchievements) {
        await showDialogAchievement(context, a);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Task task = Task();
    tasks = context.watch<TaskRepository>();
    tasksFinished = context.watch<TaskFinishedRepository>();

    return BodysUtil.bodyResponsiveHome(
        context,
        Scaffold(
            backgroundColor: const Color(0xff3B4254),
            appBar: AppBar(
              title: const Text("Pixel Tasks"),
              backgroundColor: const Color.fromARGB(255, 38, 44, 58),
              toolbarHeight: 0,
            ),
            body: Consumer<TaskRepository>(builder: (context, ts, child) {
              return CustomScrollView(slivers: [
                SliverAppBar(
                    expandedHeight: 340.0,
                    backgroundColor: Color(CharUtil.char.color).withAlpha(25),
                    flexibleSpace: FlexibleSpaceBar(
                        background: CharUtil.pixelChar(context, 0, 1))),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return taskItem(context, index, ts.list, false);
                  },
                  childCount: ts.list.isEmpty ? 1 : ts.list.length,
                )),
              ]);
            }),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  showDialogTask(context, _onCreateTask, _onEditTask, null),
              tooltip: 'New Task',
              backgroundColor: Color(CharUtil.char.color),
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: NavigationUtil.bottomNavigator(1, context)),

        //Windows

        Scaffold(
            backgroundColor: const Color(0xff3B4254),
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Row(
              children: [
                BodysUtil.navegationDesktop(context, 1),
                AnimatedContainer(
                  margin: const EdgeInsets.only(
                    left: 8.0,
                    top: 16.0,
                  ),
                  duration: const Duration(milliseconds: 250),
                  width: MediaQuery.of(context).size.width *
                          (taskSelected.key != "" ? 0.5 : 0.8) -
                      8.0,
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
                    child:
                        Consumer<TaskRepository>(builder: (context, ts, child) {
                      return Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for (int index = 0;
                                    index < tasks.list.length ||
                                        (tasks.list.isEmpty && index == 0);
                                    index++)
                                  taskItem(context, index, ts.list, true),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Card(
                                elevation: 8,
                                color: Colors.transparent,
                                child: Form(
                                  key: _formKeyTask,
                                  child: TextFormField(
                                    controller: taskController,
                                    textInputAction: TextInputAction.next,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xff3B4254),
                                      labelText: 'New Task',
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.white10),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.white54),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.red),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      errorStyle:
                                          const TextStyle(color: Colors.red),
                                    ),
                                    onChanged: (title) {
                                      task.title = title;
                                    },
                                    validator: (title) {
                                      if (title == null ||
                                          title.isEmpty ||
                                          title.length < 3) {
                                        return "Greater than 3 characters";
                                      }
                                      return null;
                                    },
                                    onEditingComplete: () {
                                      if (!_formKeyTask.currentState!
                                          .validate()) {
                                        return;
                                      }
                                      FocusScope.of(context).unfocus();
                                      taskController.text = "";
                                      task.key = UniqueKey().toString();
                                      task.date = DateTime.now();
                                      _onCreateTask(task);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                ),
                editTaskDesktop(context, taskSelected),
              ],
            )));
  }

  Widget cardDismissible(Task task, bool justRemove) {
    return InkWell(
      child: Dismissible(
        key: Key(task.key),
        direction: justRemove
            ? DismissDirection.endToStart
            : DismissDirection.horizontal,
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
        secondaryBackground: Container(
          color: const Color(0xff3B4254),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.red.withOpacity(0.8),
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.startToEnd) _onFinishTask(task);
          if (direction == DismissDirection.endToStart) _onDeleteTask(task);
        },
        child: CardTask(
          task: task,
        ),
      ),
      onTap: () {
        setState(() {
          taskSelected = task;
        });

        if (Platform.isAndroid) {
          showDialogTask(context, _onCreateTask, _onEditTask, task);
        }
        setState(() {});
      },
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

  Widget taskItem(
      BuildContext context, int index, List<Task> tasks, bool windows) {
    return ListBody(
      children: [
        if (index == 0)
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 16.0, left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "My Tasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (windows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        if (tasks.isNotEmpty &&
            HelpUtil.isToday(tasks[index].lastFinish) &&
            tasks[index].isDaily)
          cardDismissible(tasks[index], false),
        if (tasks.isNotEmpty &&
            !HelpUtil.isToday(tasks[index].lastFinish) &&
            tasks[index].isDaily)
          cardDismissible(tasks[index], true),
        if (tasks.isNotEmpty &&
            index == tasks.where((t) => t.isDaily).length &&
            index > 0)
          divider(),
        if (tasks.isNotEmpty && !tasks[index].isDaily)
          cardDismissible(tasks[index], false),
        if (index == tasks.length - 1) const SizedBox(height: 100),
      ],
    );
  }

  Widget editTaskDesktop(BuildContext context, Task taskEdit) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width:
          taskSelected.key != "" ? MediaQuery.of(context).size.width * 0.3 : 0,
      child: taskSelected.key != ""
          ? Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                        onTap: () {
                          setState(() {
                            taskSelected = Task();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: ListBody(
                        children: <Widget>[
                          const Text(
                            "Edit Task",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: TextFormField(
                              initialValue: taskEdit.title,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.white10),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.white54),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2, color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorStyle: const TextStyle(color: Colors.red),
                              ),
                              onChanged: (title) {
                                setState(() {
                                  taskEdit.title = title;
                                });
                              },
                              validator: (title) {
                                if (title == null ||
                                    title.isEmpty ||
                                    title.length < 3) {
                                  return "Greater than 3 characters";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: TextFormField(
                              initialValue: taskEdit.description,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  labelText: 'Description',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white10),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.white54),
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              onChanged: (description) {
                                setState(() {
                                  taskEdit.description = description;
                                });
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 16),
                            child: Text(
                              "Difficulty",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Slider(
                              value: taskEdit.difficulty.index.toDouble() + 1,
                              min: 1,
                              max: 3,
                              divisions: 2,
                              activeColor: taskEdit.difficulty.color,
                              inactiveColor: Colors.white10,
                              onChanged: (value) {
                                setState(
                                  () {
                                    taskEdit.difficulty =
                                        TaskUtil.getDifficultyInt(
                                            value.toInt());
                                  },
                                );
                              }),
                          Center(
                            child: Text(
                              taskEdit.difficulty.string,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: taskEdit.isDaily,
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      return Colors
                                          .white10; // Use the component's default.
                                    },
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      taskEdit.isDaily = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  "Daily",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          if (!taskEdit.isDaily)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: TextFormField(
                                controller: dateController,
                                textInputAction: TextInputAction.next,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    labelText: 'Date',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.white10),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.white54),
                                      borderRadius: BorderRadius.circular(15),
                                    )),
                                onTap: () async {
                                  taskEdit.date = DateTime.now();
                                  FocusScope.of(context).unfocus();
                                  selectDate(context, taskEdit, dateController);
                                },
                              ),
                            ),
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 16),
                              width: MediaQuery.of(context).size.width * 0.33,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xff424C5E),
                                  border: Border.all(
                                    color: const Color(0xff424C5E),
                                    width: 2,
                                  )),
                              child: TextButton(
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _onEditTask(taskEdit);
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}
