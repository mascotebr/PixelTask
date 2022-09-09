import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/char.dart';
import 'navigation_util.dart';

class BodysUtil {
  static Widget bodyResponsiveHome(
      BuildContext context, Widget bodyAndroid, Widget bodyWindows) {
    if (kIsWeb) {
      return bodyWindows;
    } else {
      return bodyAndroid;
    }
  }

  static Widget navegationDesktop(
      BuildContext context, int index, Widget pixelChar, Char char) {
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
                  color: Color(char.color).withAlpha(25),
                ),
                child: pixelChar),
          ),
          NavigationUtil.leftNavigator(index, context),
        ],
      ),
    );
  }
}
