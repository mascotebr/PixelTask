import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

Future<void> showDialogExp(BuildContext contextMain, double exp) async {
  showAnimatedDialog(
    context: contextMain,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return dialogExp(context, exp);
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.bounceInOut,
    duration: const Duration(seconds: 2),
  );
}

Widget dialogExp(BuildContext context, double exp) {
  Future.delayed(const Duration(milliseconds: 750), () {
    Navigator.pop(context);
  });
  return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.blue,
                size: 32,
              ),
              Text(
                "+${exp.round()} xp",
                style: const TextStyle(color: Colors.blue, fontSize: 32),
              )
            ],
          ),
        ],
      ));
}

Future<void> showDialogLevelUp(BuildContext contextMain, double exp) async {
  showAnimatedDialog(
    context: contextMain,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return dialogLevelUp(context, exp);
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.bounceInOut,
    duration: const Duration(seconds: 2),
  );
}

Widget dialogLevelUp(BuildContext context, double exp) {
  Future.delayed(const Duration(milliseconds: 750), () {
    Navigator.pop(context);
  });
  return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.file_upload_sharp,
                color: Colors.yellow,
                size: 32,
              ),
              const Text(
                "Level up!",
                style: TextStyle(color: Colors.yellow, fontSize: 32),
              )
            ],
          ),
        ],
      ));
}
