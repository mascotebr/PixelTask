import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel_tasks/model/task.dart';
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.task.title.trim(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                if (widget.task.description != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.task.description!.trim(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            if (widget.task.isDairy)
              Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.repeat,
                      color: HelpUtil.isToday(widget.task.lastFinish)
                          ? Colors.yellow
                          : Colors.grey)),
            if (!widget.task.isDairy)
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('dd/MM/yyyy').format(widget.task.date!),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
