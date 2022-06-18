import 'package:flutter/material.dart';
import 'package:pixel_tasks/model/char.dart';
import 'package:pixel_tasks/utils/char_util.dart';
import '../utils/navigation_util.dart';
import '../widgets/dialog_color.dart';

class PixelCharPage extends StatefulWidget {
  const PixelCharPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PixelCharPage> createState() => _PixelCharPageState();
}

class _PixelCharPageState extends State<PixelCharPage> {
  Char charInitial = Char();

  @override
  void initState() {
    readChar();
    super.initState();
  }

  Future<void> readChar() async {
    await CharUtil.setChar();
    charInitial = CharUtil.char;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff3B4254),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: const Color.fromARGB(255, 38, 44, 58),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: ListBody(
                children: <Widget>[
                  const SizedBox(
                    height: 300,
                    child: FlutterLogo(),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.white),
                    initialValue: CharUtil.char.name,
                    decoration: InputDecoration(
                        labelText: 'Name',
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
                    onChanged: (name) {
                      CharUtil.char.name = name;
                    },
                    validator: (name) {},
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8.0),
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
                            child: DropdownButton<String>(
                              value: CharUtil.char.classChar,
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
                              onChanged: (String? newValue) {
                                setState(() {
                                  CharUtil.char.classChar = newValue!;
                                });
                              },
                              items: <String>[
                                'Warrior',
                                'Thief',
                                'Mage',
                                'Cavalier'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
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
                    padding: const EdgeInsets.only(top: 8.0),
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
                          await showDialogColor(context);
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
                                  color: Color(CharUtil.char.color)),
                            ),
                          ],
                        )),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      width: MediaQuery.of(context).size.width * 0.33,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xff424C5E),
                          border: Border.all(
                            color: isDiferent(charInitial)
                                ? Colors.white
                                : const Color(0xff424C5E),
                            width: 2,
                          )),
                      child: TextButton(
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          await CharUtil.writeChar(CharUtil.char);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavigationUtil.bottomNavigator(0, context));
  }

  bool isDiferent(Char char) {
    if (CharUtil.char.name != char.name ||
        CharUtil.char.classChar != char.classChar ||
        CharUtil.char.color != char.color) {
      return true;
    }

    return false;
  }
}
