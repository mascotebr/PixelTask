import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_tasks/model/task.dart';

Future<void> showDialogTask(
    BuildContext contextMain, Function createTask) async {
  Task task = Task();
  TextEditingController dateController = TextEditingController();

  return showDialog<void>(
    context: contextMain,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext contextStf, setState) {
        return AlertDialog(
          elevation: 8,
          title: const Text(
            'New Task',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xff3B4254),
          content: SingleChildScrollView(
            child: Form(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
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
                        )),
                    onChanged: (title) {
                      task.title = title;
                    },
                    validator: (title) {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
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
                        task.description = description;
                      },
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
                            task.isDairy = value!;
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
                        selectDate(contextStf, task, dateController);
                      },
                      validator: (title) {},
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
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                task.key = UniqueKey().toString();
                createTask(task);
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
