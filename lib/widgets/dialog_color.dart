import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../model/char.dart';
import '../utils/design_util.dart';

Future<void> showDialogColor(BuildContext contextMain, Char char) async {
  return showDialog<void>(
    context: contextMain,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext contextStf, setState) {
        return AlertDialog(
          elevation: 8,
          title: const Text(
            'Select Color',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: DesignUtil.gray,
          content: SingleChildScrollView(
              child: BlockPicker(
            pickerColor: Color(char.color), //default color
            onColorChanged: (Color color) {
              setState(() {
                char.color = color.value;
              });
            },
          )),
          actions: <Widget>[
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
                'Select',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    },
  );
}
