import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alerts {
  static void buildCupertinoDialog(
      {@required String title,
      @required List<Widget> actions,
      @required BuildContext context,
      @required Widget content}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: content,
            actions: actions,
          );
        });
  }
}
