import 'dart:io';

import 'package:contratacao_funcionarios/src/blocs/account_user_bloc.dart';
import 'package:contratacao_funcionarios/src/shared/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DownloadInputButton extends StatelessWidget {
  final AccountUserBloc _bloc;

  DownloadInputButton(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.0,
                style: BorderStyle.solid,
                color: const Color.fromRGBO(210, 210, 210, 1)),
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
          ),
        ),
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.download,
                size: 18,
                color: Colors.grey[700],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Anexar currículo",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                    color: Colors.grey[700]),
              ),
            ],
          ),
          color: Colors.white,
          onPressed: () async {
            this._bloc.curriculum = await FilePicker.getMultiFile(
                fileExtension: 'pdf', type: FileType.CUSTOM);
          },
        ));
  }
}
