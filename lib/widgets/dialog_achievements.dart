import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:pixel_tasks/model/achievements.dart';
import 'package:pixel_tasks/utils/char_util.dart';

Future<void> showDialogAchievement(
    BuildContext contextMain, Achievements achievement) async {
  showAnimatedDialog(
    context: contextMain,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return dialogAchiement(context, achievement);
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.bounceInOut,
    duration: const Duration(seconds: 2),
  );
}

Widget dialogAchiement(BuildContext context, Achievements achievement) {
  Future.delayed(const Duration(milliseconds: 3000), () {
    Navigator.pop(context);
  });
  return AlertDialog(
      elevation: 8,
      backgroundColor: const Color(0xff3B4254),
      content: SizedBox(
        height: 100,
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CharUtil.medalImage(achievement.medal!),
                Text(
                  achievement.name!,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                )
              ],
            ),
          ],
        ),
      ));
}
