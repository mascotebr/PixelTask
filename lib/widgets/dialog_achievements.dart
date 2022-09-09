import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:pixel_tasks/model/achievements.dart';

import '../utils/design_util.dart';

Future<void> showDialogAchievement(BuildContext contextMain,
    Achievements achievement, Widget medalImage) async {
  showAnimatedDialog(
    context: contextMain,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return dialogAchiement(context, achievement, medalImage);
    },
    animationType: DialogTransitionType.scale,
    curve: Curves.bounceInOut,
    duration: const Duration(seconds: 2),
  );
}

Widget dialogAchiement(
    BuildContext context, Achievements achievement, Widget medalImage) {
  return AlertDialog(
      elevation: 8,
      backgroundColor: DesignUtil.gray,
      content: SizedBox(
        height: 200,
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                medalImage,
                Text(
                  achievement.name!,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black.withOpacity(0.5);
                          }
                          return const Color.fromARGB(
                              255, 38, 44, 58); // Use the component's default.
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
                ),
              ],
            ),
          ],
        ),
      ));
}
