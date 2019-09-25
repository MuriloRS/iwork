import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:contratacao_funcionarios/src/shared/email.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum EMAIL_STATE { SENDING, SENDED, EMPTY, ERROR }

class EmailBloc extends BlocBase {
  BuildContext context;
  String errorMessage;

  var emailController = BehaviorSubject<EMAIL_STATE>();
  var emailDataController = BehaviorSubject<Map>();

  Stream<EMAIL_STATE> get outEmail => emailController.stream;
  Stream<Map> get outEmailData => emailDataController.stream;

  Sink<EMAIL_STATE> get doEmail => emailController.sink;
  Sink<Map> get doDataEmail => emailDataController.sink;

  EmailBloc(this.context) {
    emailDataController.stream.listen(_sendEmail);
    emailController.stream.listen(_emailState);
  }

  void _emailState(EMAIL_STATE state) {
    switch (state) {
      case EMAIL_STATE.ERROR:
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                errorMessage,
                style: TextStyle(
                  fontSize: 16,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 8),
        ));
        break;
      case EMAIL_STATE.SENDED:
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AutoSizeText(
                'Email enviado!',
                style: TextStyle(fontSize: 16),
                maxLines: 3,
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.tag_faces)
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 8),
        ));
        break;
      default:
    }
  }

  void _sendEmail(Map emailData) async {
    emailController.add(EMAIL_STATE.SENDING);

    try {
      if (emailData['body'] == '' && emailData['subject'] == '') {
        this.errorMessage =
            'O assunto e mensagem do \n email são obrigatórios.';

        emailController.add(EMAIL_STATE.ERROR);
        return;
      } else {
        if (emailData['body'] == '') {
          this.errorMessage = 'A mensagem do email é \nobrigatória';
          emailController.add(EMAIL_STATE.ERROR);
          return;
        }

        if (emailData['subject'] == '') {
          this.errorMessage = 'O assunto do email é \n obrigatório';
          emailController.add(EMAIL_STATE.ERROR);
          return;
        }
      }

      await Email.sendEmail(emailData['body'], emailData['emailUser'],
          'murilo_haas@outlook.com', emailData['subject']);

      emailController.add(EMAIL_STATE.SENDED);
    } catch (e) {
      emailController.add(EMAIL_STATE.ERROR);
    }
  }

  @override
  void dispose() {
    super.dispose();

    emailController.close();
    emailDataController.close();
  }
}
