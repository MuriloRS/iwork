import 'package:contratacao_funcionarios/src/blocs/email_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:contratacao_funcionarios/src/shared/default_sliver_scaffold.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ContactTab extends StatelessWidget {
  TextEditingController _controllerSubject;
  TextEditingController _controllerText;
  UserModel _model;

  EmailBloc bloc;

  @override
  Widget build(BuildContext context) {
    _controllerSubject = TextEditingController();
    _controllerText = TextEditingController();
    bloc = EmailBloc(context);
    _model = Provider.of<UserModel>(context);

    return DefaultSliverScaffold(
        titleScaffold: "Contato",
        content: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Assunto",
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).cardColor)),
                SizedBox(
                  height: 5,
                ),
                InputField(
                    _controllerSubject,
                    false,
                    TextInputType.text,
                    '',
                    [
                      FormBuilderValidators.required(
                          errorText: 'O assunto é obrigatório')
                    ],
                    null,
                    null,
                    'subject',
                    false),
                SizedBox(
                  height: 20,
                ),
                Text("Descrição",
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).cardColor)),
                SizedBox(
                  height: 5,
                ),
                InputField(
                    _controllerText,
                    false,
                    TextInputType.multiline,
                    '',
                    [
                      FormBuilderValidators.required(
                          errorText: 'A descrição do email é obrigatório')
                    ],
                    null,
                    null,
                    'email',
                    false),
                SizedBox(
                  height: 25,
                ),
                StreamBuilder(
                  stream: bloc.emailController,
                  builder: (context, AsyncSnapshot<EMAIL_STATE> snapshot) {
                    switch (snapshot.data) {
                      case EMAIL_STATE.SENDING:
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Loader(),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Enviando...",
                                style: TextStyle(fontSize: 18, color: Colors.white))
                          ],
                        );
                        break;

                      default:
                        return ButtonInput.getButton(
                            TYPE_BUTTON.IMAGE, COLOR_BUTTON.PRIMARY, 'Enviar',
                            () {
                          bloc.emailDataController.add({
                            'subject': _controllerSubject.text,
                            'body': _controllerText.text,
                            'email': _model.email
                          });

                          _controllerSubject.text = "";
                          _controllerText.text = "";
                        },
                            context,
                            Icon(
                              FontAwesomeIcons.paperPlane,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ), 20);
                    }
                  },
                )
              ],
            )));
  }
}
