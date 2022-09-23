import 'package:flutter/cupertino.dart';

class PageService extends ChangeNotifier {
  int page = 0;

  Widget floatBottomButton = Container();

  PageService();
  setPage(int p) {
    page = p;
    notifyListeners();
  }

  setFloatBottomButton(Widget button) async {
    await Future.delayed(const Duration(seconds: 1));
    floatBottomButton = button;
    notifyListeners();
  }
}
