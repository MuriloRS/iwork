import 'package:contratacao_funcionarios/src/shared/alerts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckboxContractTerms extends StatefulWidget {
  static bool checked = false;
  @override
  _CheckboxTermosContratoState createState() => _CheckboxTermosContratoState();
}

class _CheckboxTermosContratoState extends State<CheckboxContractTerms> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width / 1.3,
      alignment: Alignment.center,
      child: FlatButton(
          onPressed: () {},
          child: CheckboxListTile(
            onChanged: (newValue) {
              
            },
            selected: false,
            title: Text(
              "Aceito os termos de serviço.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ), //    <-- label
            value: CheckboxContractTerms.checked,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
          )),
    );
  }
}
