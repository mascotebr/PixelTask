import 'dart:io';

import 'package:flutter/material.dart';

import '../model/task.dart';
import 'char_util.dart';
import 'navigation_util.dart';

class BodysUtil {
  static Widget bodyResponsiveHome(
      BuildContext context, Widget bodyAndroid, Widget bodyWindows) {
    if (Platform.isWindows) {
      return bodyWindows;
    } else {
      return bodyAndroid;
    }
  }

  static Widget navegationDesktop(BuildContext context, int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(CharUtil.char.color).withAlpha(25),
                ),
                child: CharUtil.pixelChar(
                    context, MediaQuery.of(context).size.width * 0.8, 0.2)),
          ),
          NavigationUtil.leftNavigator(index, context),
        ],
      ),
    );
  }
}
