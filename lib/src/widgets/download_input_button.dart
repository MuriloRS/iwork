import 'dart:io';

import 'package:contratacao_funcionarios/src/blocs/account_user_bloc.dart';
import 'package:contratacao_funcionarios/src/shared/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;

class DownloadInputButton extends StatefulWidget {
  final AccountUserBloc _bloc;

  DownloadInputButton(this._bloc);
  @override
  _DownloadInputButtonState createState() => _DownloadInputButtonState();
}

class _DownloadInputButtonState extends State<DownloadInputButton> {
  bool isCurriculumLoaded = false;
  String basename;
  @override
  Widget build(BuildContext context) {
    basename = widget._bloc.curriculum != null
        ? p.basename(widget._bloc.curriculum.path)
        : '';

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
          child: !isCurriculumLoaded
              ? Row(
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
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.filePdf,
                      size: 18,
                      color: Colors.grey[800],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      basename,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
          color: Colors.white,
          onPressed: () async {
            widget._bloc.curriculum = await FilePicker.getFile(
                fileExtension: 'pdf', type: FileType.CUSTOM);

            if (widget._bloc.curriculum != null) {
              setState(() {
                isCurriculumLoaded = true;
              });
            }
          },
        ));
  }
}
