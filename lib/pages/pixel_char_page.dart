import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pixel_tasks/model/char.dart';
import 'package:pixel_tasks/model/class_char.dart';
import 'package:pixel_tasks/pages/achievements_page.dart';
import 'package:pixel_tasks/services/auth_service.dart';
import 'package:pixel_tasks/services/char_repository.dart';
import 'package:pixel_tasks/services/page_service.dart';
import 'package:provider/provider.dart';
import '../utils/bodys_util.dart';
import '../utils/design_util.dart';

import '../widgets/dialog_color.dart';

class PixelCharPage extends StatefulWidget {
  const PixelCharPage({Key? key}) : super(key: key);

  @override
  State<PixelCharPage> createState() => _PixelCharPageState();
}

class _PixelCharPageState extends State<PixelCharPage> {
  Char charUpdate = Char();
  late CharRepository char;
  late PageService pages;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    char = context.watch<CharRepository>();
    pages = context.watch<PageService>();
    if (charUpdate.key != char.single.key) _setCharUpdate();

    return BodysUtil.bodyResponsiveHome(
        context,
        Scaffold(
          backgroundColor: DesignUtil.gray,
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: ListBody(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 340,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(180.0),
                          ),
                          color: Color(char.single.color).withAlpha(25),
                        ),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Image.asset(
                          charUpdate.classChar.image,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            child: Image.asset(
                              "images/medals/medal1.png",
                              scale: 1,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      const AchievementsPage(),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      "My Char",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(color: Colors.white),
                      initialValue: charUpdate.name,
                      decoration: InputDecoration(
                          labelText: 'Name',
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
                      onChanged: (name) {
                        charUpdate.name = name.trim();
                        setState(() {});
                      },
                      validator: (value) {
                        if (value != null && value.length > 20) {
                          return "ame is too big";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white10,
                          width: 2,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 8.0),
                          child: Text(
                            "Class",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: DropdownButton<ClassChar>(
                              value: char.single.classChar,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xff424C5E),
                              ),
                              elevation: 16,
                              dropdownColor: const Color(0xff424C5E),
                              style: const TextStyle(color: Colors.white),
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: (ClassChar? newValue) {
                                setState(() {
                                  charUpdate.classChar = char.listAchievements
                                      .firstWhere((e) => e == newValue);
                                });
                              },
                              items: char.listAchievements
                                  .map<DropdownMenuItem<ClassChar>>(
                                      (ClassChar value) {
                                return DropdownMenuItem<ClassChar>(
                                  value: value,
                                  child: Text(
                                    value.string,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                    child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              return const Color(
                                  0xff424C5E); // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () async {
                          await showDialogColor(context, charUpdate);
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Select Color",
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.circle,
                                  color: Color(charUpdate.color)),
                            ),
                          ],
                        )),
                  ),
                  Opacity(
                    opacity: isDiferent(charUpdate) ? 1 : 0.5,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 16),
                        width: MediaQuery.of(context).size.width * 0.33,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff424C5E),
                        ),
                        child: TextButton(
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            if (isDiferent(charUpdate) &&
                                formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              // await CharUtil.writeChar(CharUtil.char);
                              await char.save(charUpdate);
                              charUpdate = char.single;
                              Fluttertoast.showToast(
                                  msg: 'Saved',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.white,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0);
                              _setCharUpdate();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: OutlinedButton(
                        onPressed: () async {
                          pages.setPage(0);
                          await context.read<AuthService>().logout(context);
                        },
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Logout",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
        Container());

    //Windows

    // Scaffold(
    //     backgroundColor: DesignUtil.gray,
    //     appBar: AppBar(
    //       toolbarHeight: 0,
    //       backgroundColor: Colors.transparent,
    //     ),
    //     body: Row(
    //       children: [
    //         BodysUtil.navegationDesktop(
    //             context,
    //             0,
    //             char.pixelChar(
    //                 context, MediaQuery.of(context).size.width * 0.8, 0.2),
    //             char.single,
    //             null),
    //         Container(
    //           margin: const EdgeInsets.only(
    //             left: 8.0,
    //             top: 16.0,
    //           ),
    //           width: MediaQuery.of(context).size.width * 0.8 - 8.0,
    //           height: MediaQuery.of(context).size.height,
    //           decoration: BoxDecoration(
    //             borderRadius: const BorderRadius.only(
    //               topLeft: Radius.circular(15.0),
    //             ),
    //             color: Colors.black.withOpacity(0.1),
    //           ),
    //           child: Center(
    //             child: SizedBox(
    //               width: MediaQuery.of(context).size.width * 0.5,
    //               height: MediaQuery.of(context).size.height,
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   TextFormField(
    //                     textInputAction: TextInputAction.next,
    //                     style: const TextStyle(color: Colors.white),
    //                     initialValue: charUpdate.name,
    //                     decoration: InputDecoration(
    //                         labelText: 'Name',
    //                         labelStyle:
    //                             const TextStyle(color: Colors.white),
    //                         enabledBorder: OutlineInputBorder(
    //                           borderSide: const BorderSide(
    //                               width: 2, color: Colors.white10),
    //                           borderRadius: BorderRadius.circular(15),
    //                         ),
    //                         focusedBorder: OutlineInputBorder(
    //                           borderSide: const BorderSide(
    //                               width: 2, color: Colors.white54),
    //                           borderRadius: BorderRadius.circular(15),
    //                         )),
    //                     onChanged: (name) {
    //                       setState(() {
    //                         charUpdate.name = name.trim();
    //                       });
    //                     },
    //                   ),
    //                   Container(
    //                     margin: const EdgeInsets.only(top: 8.0),
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(15),
    //                         border: Border.all(
    //                           color: Colors.white10,
    //                           width: 2,
    //                         )),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const Padding(
    //                           padding:
    //                               EdgeInsets.only(top: 15.0, left: 8.0),
    //                           child: Text(
    //                             "Class",
    //                             style: TextStyle(
    //                                 color: Colors.white, fontSize: 16),
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.only(
    //                               left: 8.0, right: 8.0),
    //                           child: SizedBox(
    //                             width:
    //                                 MediaQuery.of(context).size.width * 0.4,
    //                             child: DropdownButton<ClassChar>(
    //                               value: charUpdate.classChar,
    //                               icon: const Icon(
    //                                 Icons.arrow_drop_down,
    //                                 color: Color(0xff424C5E),
    //                               ),
    //                               elevation: 16,
    //                               dropdownColor: const Color(0xff424C5E),
    //                               style:
    //                                   const TextStyle(color: Colors.white),
    //                               underline: Container(
    //                                 height: 0,
    //                               ),
    //                               onChanged: (ClassChar? newValue) {
    //                                 setState(() {
    //                                   charUpdate.classChar = char
    //                                       .listAchievements
    //                                       .firstWhere((e) => e == newValue);
    //                                 });
    //                               },
    //                               items: char.listAchievements
    //                                   .map<DropdownMenuItem<ClassChar>>(
    //                                       (ClassChar value) {
    //                                 return DropdownMenuItem<ClassChar>(
    //                                   value: value,
    //                                   child: Text(
    //                                     value.string,
    //                                     style: const TextStyle(
    //                                         color: Colors.white),
    //                                   ),
    //                                 );
    //                               }).toList(),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: const EdgeInsets.only(top: 8.0),
    //                     child: TextButton(
    //                         style: ButtonStyle(
    //                           backgroundColor:
    //                               MaterialStateProperty.resolveWith<Color?>(
    //                             (Set<MaterialState> states) {
    //                               return const Color(
    //                                   0xff424C5E); // Use the component's default.
    //                             },
    //                           ),
    //                         ),
    //                         onPressed: () async {
    //                           await showDialogColor(context, charUpdate);
    //                           setState(() {});
    //                         },
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           crossAxisAlignment: CrossAxisAlignment.center,
    //                           children: [
    //                             const Text(
    //                               "Select Color",
    //                               style: TextStyle(color: Colors.white),
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.only(left: 8.0),
    //                               child: Icon(Icons.circle,
    //                                   color: Color(charUpdate.color)),
    //                             ),
    //                           ],
    //                         )),
    //                   ),
    //                   Center(
    //                     child: Container(
    //                       margin: const EdgeInsets.only(top: 16),
    //                       width: MediaQuery.of(context).size.width * 0.33,
    //                       height: 45,
    //                       decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(15),
    //                           color: const Color(0xff424C5E),
    //                           border: Border.all(
    //                             color: isDiferent(charUpdate)
    //                                 ? Colors.white
    //                                 : const Color(0xff424C5E),
    //                             width: 2,
    //                           )),
    //                       child: TextButton(
    //                         child: const Text(
    //                           'Save',
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                           ),
    //                         ),
    //                         onPressed: () async {
    //                           // await CharUtil.writeChar(CharUtil.char);
    //                           char.save(charUpdate);
    //                           Fluttertoast.showToast(
    //                               msg: 'Saved',
    //                               toastLength: Toast.LENGTH_SHORT,
    //                               gravity: ToastGravity.BOTTOM,
    //                               textColor: Colors.white,
    //                               timeInSecForIosWeb: 1,
    //                               fontSize: 16.0);
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         )
    //       ],
    //     )));
  }

  bool isDiferent(Char c) {
    if (char.single.name != c.name ||
        char.single.classChar != c.classChar ||
        char.single.color != c.color) {
      return true;
    }

    return false;
  }

  _setCharUpdate() {
    charUpdate.key = char.single.key;
    charUpdate.achievements = char.single.achievements;
    charUpdate.classChar = char.single.classChar;
    charUpdate.color = char.single.color;
    charUpdate.experience = char.single.experience;
    charUpdate.expMax = char.single.expMax;
    charUpdate.level = char.single.level;
    charUpdate.name = char.single.name;
  }
}
