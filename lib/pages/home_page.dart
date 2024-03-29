import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_tasks/model/Difficulty.dart';
import 'package:pixel_tasks/model/achievements.dart';
import 'package:pixel_tasks/services/page_service.dart';
import 'package:pixel_tasks/utils/navigation_util.dart';
import 'package:pixel_tasks/utils/bodys_util.dart';
import 'package:pixel_tasks/widgets/card_task.dart';
import 'package:pixel_tasks/widgets/dialog_task.dart';
import 'package:provider/provider.dart';
import '../model/task.dart';
import '../services/char_repository.dart';
import '../services/task_finished_repository.dart';
import '../services/task_repository.dart';
import '../utils/design_util.dart';
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
  late CharRepository char;
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

    if (char.single.exp + exp >= char.maxExp) {
      showDialogLevelUp(context, exp);
    } else {
      showDialogExp(context, exp);
    }

    task.lastFinish = DateTime.now();

    if (!task.isDaily) {
      tasks.remove(task);
    }

    tasksFinished.save(task);

    char.addExp(exp.round());

    List<Achievements> newsAchievements =
        await char.checkAchivements(tasksFinished.list);

    newAchievementsDialogs(newsAchievements);

    if (task.isDaily) {
      await Future.delayed(const Duration(seconds: 3), () {
        tasks.save(task);
      });
    }
  }

  Future<void> _onDeleteTask(Task task) async {
    tasks.remove(task);
  }

  Future<void> newAchievementsDialogs(
      List<Achievements> newsAchievements) async {
    if (newsAchievements.isNotEmpty) {
      for (var a in newsAchievements) {
        await showDialogAchievement(context, a, char.medalImage(a.medal!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    char = context.watch<CharRepository>();
    tasks = context.watch<TaskRepository>();
    tasksFinished = context.watch<TaskFinishedRepository>();

    return Scaffold(
      backgroundColor: DesignUtil.darkGray,
      appBar: AppBar(
        title: const Text("Pixel Tasks"),
        backgroundColor: DesignUtil.darkGray,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "My Tasks",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 68.0),
              child: tasks.list.isNotEmpty
                  ? ListView.builder(
                      itemCount: tasks.list.length,
                      itemBuilder: (context, index) {
                        return taskItem(context, index, tasks.list);
                      },
                    )
                  : Container())
        ],
      ),
      floatingActionButton: addButton(),
    );

    //Windows

    // Scaffold(
    //     backgroundColor: DesignUtil.gray,
    //     appBar: AppBar(
    //       toolbarHeight: 0,
    //       backgroundColor: Colors.transparent,
    //     ),
    //     body: Row(
    //       children: [
    //         BodysUtil.navegationDesktop(
    //             context,
    //             1,
    //             char.pixelChar(
    //                 context, MediaQuery.of(context).size.width * 0.8, 0.2),
    //             char.single),
    //         AnimatedContainer(
    //           margin: const EdgeInsets.only(
    //             left: 8.0,
    //             top: 16.0,
    //           ),
    //           duration: const Duration(milliseconds: 250),
    //           width: MediaQuery.of(context).size.width *
    //                   (taskSelected.key != "" ? 0.5 : 0.8) -
    //               8.0,
    //           height: MediaQuery.of(context).size.height,
    //           decoration: BoxDecoration(
    //             borderRadius: const BorderRadius.only(
    //               topLeft: Radius.circular(15.0),
    //             ),
    //             color: Colors.black.withOpacity(0.1),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.only(
    //                 left: 24.0, right: 24.0, top: 16.0),
    //             child:
    //                 Consumer<TaskRepository>(builder: (context, ts, child) {
    //               return Stack(
    //                 children: [
    //                   SingleChildScrollView(
    //                     child: Column(
    //                       children: [
    //                         for (int index = 0;
    //                             index < ts.list.length ||
    //                                 (ts.list.isEmpty && index == 0);
    //                             index++)
    //                           taskItem(context, index, ts.list, true),
    //                       ],
    //                     ),
    //                   ),
    //                   Align(
    //                     alignment: Alignment.bottomCenter,
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(12.0),
    //                       child: Card(
    //                         elevation: 8,
    //                         color: Colors.transparent,
    //                         child: Form(
    //                           key: _formKeyTask,
    //                           child: TextFormField(
    //                             controller: taskController,
    //                             textInputAction: TextInputAction.next,
    //                             style: const TextStyle(color: Colors.white),
    //                             decoration: InputDecoration(
    //                               prefixIcon: const Icon(
    //                                 Icons.add,
    //                                 color: Colors.white,
    //                               ),
    //                               filled: true,
    //                               fillColor: DesignUtil.gray,
    //                               labelText: 'New Task',
    //                               labelStyle:
    //                                   const TextStyle(color: Colors.white),
    //                               enabledBorder: OutlineInputBorder(
    //                                 borderSide: const BorderSide(
    //                                     width: 2, color: Colors.white10),
    //                                 borderRadius: BorderRadius.circular(4),
    //                               ),
    //                               focusedBorder: OutlineInputBorder(
    //                                 borderSide: const BorderSide(
    //                                     width: 2, color: Colors.white54),
    //                                 borderRadius: BorderRadius.circular(4),
    //                               ),
    //                               errorBorder: OutlineInputBorder(
    //                                 borderSide: const BorderSide(
    //                                     width: 2, color: Colors.red),
    //                                 borderRadius: BorderRadius.circular(4),
    //                               ),
    //                               errorStyle:
    //                                   const TextStyle(color: Colors.red),
    //                             ),
    //                             onChanged: (title) {
    //                               task.title = title;
    //                             },
    //                             validator: (title) {
    //                               if (title == null ||
    //                                   title.isEmpty ||
    //                                   title.length < 3) {
    //                                 return "Greater than 3 characters";
    //                               }
    //                               return null;
    //                             },
    //                             onEditingComplete: () {
    //                               if (!_formKeyTask.currentState!
    //                                   .validate()) {
    //                                 return;
    //                               }
    //                               FocusScope.of(context).unfocus();
    //                               taskController.text = "";
    //                               task.key = UniqueKey().toString();
    //                               task.date = DateTime.now();
    //                               _onCreateTask(task);
    //                             },
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               );
    //             }),
    //           ),
    //         ),
    //         editTaskDesktop(context, taskSelected),
    //       ],
    //     )
    //     ));
  }

  Widget addButton() {
    return FloatingActionButton(
      onPressed: () =>
          showDialogTask(context, _onCreateTask, _onEditTask, null),
      tooltip: 'New Task',
      backgroundColor: DesignUtil.gray,
      child: const Icon(
        Icons.add,
        size: 32,
      ),
      elevation: 8,
    );
  }

  Widget cardDismissible(Task task, bool justRemove) {
    return InkWell(
      child: Dismissible(
        key: Key(task.key),
        direction: justRemove
            ? DismissDirection.endToStart
            : DismissDirection.horizontal,
        background: Container(
          color: DesignUtil.darkGray,
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
          color: DesignUtil.darkGray,
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

        if (!kIsWeb) {
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
              color: DesignUtil.gray,
              height: 3,
              width: MediaQuery.of(context).size.width * 0.42,
            ),
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_circle_down,
                color: DesignUtil.gray,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                color: DesignUtil.gray,
                height: 3,
                width: MediaQuery.of(context).size.width * 0.42,
              ),
            ),
          ],
        ));
  }

  Widget taskItem(BuildContext context, int index, List<Task> tasks) {
    return Column(
      children: [
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
