import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_tasks/model/task.dart';
import 'package:pixel_tasks/model/Difficulty.dart';
import 'package:pixel_tasks/utils/task_util.dart';

Future<void> showDialogTask(BuildContext contextMain, Function createTask,
    Function editTask, Task? task) async {
  task ??= Task();
  TextEditingController dateController =
      TextEditingController(text: DateFormat('MM/dd/yyyy').format(task.date!));
  final _formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: contextMain,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext contextStf, setState) {
        return AlertDialog(
          elevation: 8,
          title: Text(
            task!.key == '' ? 'New Task' : 'Edit Task',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xff3B4254),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    initialValue: task.title,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white10),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white54),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                    onChanged: (title) {
                      task!.title = title;
                    },
                    validator: (title) {
                      if (title == null || title.isEmpty || title.length < 3) {
                        return "Greater than 3 characters";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      initialValue: task.description,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: const TextStyle(color: Colors.white),
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
                        task!.description = description;
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
                      value: task.difficulty.index.toDouble() + 1,
                      min: 1,
                      max: 3,
                      divisions: 2,
                      activeColor: task.difficulty.color,
                      inactiveColor: Colors.white10,
                      onChanged: (value) {
                        setState(
                          () {
                            task!.difficulty =
                                TaskUtil.getDifficultyInt(value.toInt());
                          },
                        );
                      }),
                  Center(
                    child: Text(
                      task.difficulty.string,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: task.isDairy,
                        fillColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            return Colors
                                .white10; // Use the component's default.
                          },
                        ),
                        onChanged: (value) {
                          setState(() {
                            task!.isDairy = value!;
                          });
                        },
                      ),
                      const Text(
                        "Daily",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  if (!task.isDairy)
                    TextFormField(
                      controller: dateController,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: const TextStyle(color: Colors.white),
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
                      onTap: () {
                        FocusScope.of(contextStf).unfocus();
                        selectDate(contextStf, task!, dateController);
                        setState(() {});
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.red.withOpacity(0.5);
                    }
                    return Colors.red; // Use the component's default.
                  },
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.green.withOpacity(0.5);
                    }
                    return Colors.green; // Use the component's default.
                  },
                ),
              ),
              child: Text(
                task.key == "" ? 'Create' : "Edit",
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                if (task!.key == "") {
                  task.key = UniqueKey().toString();
                  createTask(task);
                } else {
                  editTask(task);
                }
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    },
  );
}

void selectDate(BuildContext context, Task task,
    TextEditingController dateController) async {
  DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: task.date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (contextT, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            dialogBackgroundColor: const Color(0xff3B4254),
          ),
          child: child!,
        );
      });

  if (newSelectedDate != null) {
    task.date = newSelectedDate;
    dateController
      ..text = DateFormat.yMd().format(task.date!)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: dateController.text.length, affinity: TextAffinity.upstream));
  }
}
