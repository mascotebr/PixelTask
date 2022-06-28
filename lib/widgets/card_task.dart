import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_tasks/model/task.dart';
import 'package:pixel_tasks/model/Difficulty.dart';
import 'package:pixel_tasks/utils/help_util.dart';

class CardTask extends StatefulWidget {
  const CardTask({Key? key, required this.task}) : super(key: key);
  final Task task;

  @override
  State<CardTask> createState() => _CardTaskState();
}

class _CardTaskState extends State<CardTask> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: !HelpUtil.isToday(widget.task.lastFinish) ? 0.5 : 1,
      child: Card(
        color: const Color(0xff424C5E),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Padding(
          padding: EdgeInsets.only(
              top: 12.0,
              bottom: widget.task.description == null ? 24.0 : 12.0,
              left: 16.0,
              right: 16.0),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Wrap(
                    children: [
                      Text(
                        widget.task.title.trim(),
                        textScaleFactor: Platform.isAndroid ? 1 : 0.8,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Icon(
                          Icons.flag,
                          color: widget.task.difficulty.color,
                          size: 12,
                        ),
                      )
                    ],
                  ),
                ),
                if (widget.task.description != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.task.description!.trim(),
                      textScaleFactor: Platform.isAndroid ? 1 : 0.8,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            if (widget.task.repeat > 0)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0, top: 6.0),
                  child: Text(
                    "${widget.task.repeat}",
                    textScaleFactor: Platform.isAndroid ? 1 : 0.8,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            if (widget.task.isDairy)
              Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.repeat,
                      color: widget.task.repeat > 0
                          ? Colors.grey
                          : HelpUtil.isToday(widget.task.lastFinish)
                              ? Colors.yellow
                              : Colors.grey)),
            if (!widget.task.isDairy)
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('MM/dd/yyyy').format(widget.task.date!),
                  textScaleFactor: Platform.isAndroid ? 1 : 0.8,
                  style: TextStyle(
                      color: DateTime.now().isBefore(
                              widget.task.date!.add(const Duration(days: 1)))
                          ? Colors.white
                          : Colors.red.shade300),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
