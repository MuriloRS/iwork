import 'package:contratacao_funcionarios/src/blocs/account_user_bloc.dart';
import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:contratacao_funcionarios/src/shared/file_picker.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;

class DownloadInputButton extends StatefulWidget {
  final AccountUserBloc _bloc;
  final UserModel _model;

  DownloadInputButton(this._bloc, this._model);
  @override
  _DownloadInputButtonState createState() => _DownloadInputButtonState();
}

class _DownloadInputButtonState extends State<DownloadInputButton> {
  bool isCurriculumLoaded = false;
  String basename;
  UserBloc _userBloc;

  @override
  Widget build(BuildContext context) {
    basename = widget._model.curriculum == '' && isCurriculumLoaded
        ? p.basename(widget._bloc.curriculum.path)
        : widget._model.curriculum;

    _userBloc = UserBloc();

    return FutureBuilder(
      future: _userBloc.getCurriculumUser(basename, widget._model.documentId),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState.index == ConnectionState.none.index ||
            snapshot.connectionState.index == ConnectionState.waiting.index) {
          return Loader();
        } else {
          return Column(
            children: <Widget>[
              Container(
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
                    child: !isCurriculumLoaded && widget._model.curriculum == ''
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
                      if (widget._model.curriculum != '') {
                        widget._bloc.openPdf(snapshot.data);
                      } else {
                        widget._bloc.curriculum = await FilePicker.getFile(
                            fileExtension: 'pdf', type: FileType.CUSTOM);

                        if (widget._bloc.curriculum != null) {
                          setState(() {
                            isCurriculumLoaded = true;
                          });
                        }
                      }
                    },
                  )),
              !isCurriculumLoaded && widget._model.curriculum == ''
                  ? Text(
                      "Anexe o pdf do seu currículo.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    )
                  : FlatButton(
                      child: Text(
                        "Excluir currículo",
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      color: Colors.transparent,
                      textColor: Colors.red,
                      onPressed: () {
                        widget._bloc.deleteCurriculum(widget._model);

                        setState(() {
                          isCurriculumLoaded = false;
                        });
                      },
                    ),
            ],
          );
        }
      },
    );
  }
}
