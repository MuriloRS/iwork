import 'package:flutter/material.dart';

class TitleScaffold extends StatelessWidget {
  final String title;

  TitleScaffold({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
