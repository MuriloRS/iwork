import 'package:contratacao_funcionarios/src/shared/default_sliver_scaffold.dart';
import 'package:flutter/material.dart';

class ContactTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultSliverScaffold(
        titleScaffold: "Contato",
        content: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              children: <Widget>[],
            )));
  }
}
