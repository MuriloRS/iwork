import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            strokeWidth: 4.0,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.green[600]),
          )),
    );
  }
}
