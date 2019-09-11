import 'package:contratacao_funcionarios/src/blocs/recover_password_bloc.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:contratacao_funcionarios/src/widgets/title_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RecoverScreen extends StatefulWidget {
  

  @override
  _RecoverScreenState createState() => _RecoverScreenState();
}

class _RecoverScreenState extends State<RecoverScreen> {

  TextEditingController _emailController;
  RecoverPasswordBloc loginBloc = new RecoverPasswordBloc();

  @override
  void initState() {
    super.initState();

    loginBloc.outState.listen((state) {
      switch (state) {
        case RecoverPasswordState.SUCCESS:
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                "Um email para recuperação de senha foi enviado para seu email."),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 7),
          ));

          Future.delayed(Duration(seconds: 7));

          Navigator.pop(context);

          return Container();
          break;
        default:
          return Container();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    _emailController  = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TitleScaffold(title: "Recuperar Senha",),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            children: <Widget>[
              Text(
                "Digite seu email para recuperar sua senha",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10.0,
              ),
              InputField(
                  _emailController,
                  false,
                  TextInputType.emailAddress,
                  'Email',
                  [
                    FormBuilderValidators.email(
                        errorText: "Formato de email inválido"),
                    FormBuilderValidators.max(40),
                  ],
                  loginBloc.outEmail,
                  loginBloc.changeEmail,
                  "recoverEmail", false),
              SizedBox(height: 15.0),
              StreamBuilder(
                stream: loginBloc.outState,
                builder: (context, AsyncSnapshot<RecoverPasswordState> snapshot) {
                  switch (snapshot.data) {
                    case RecoverPasswordState.IDLE:
                      return _buildButtonSend(email: _emailController.text);
                      break;
                    case RecoverPasswordState.LOADING:
                      return Loader();

                    default:
                      return _buildButtonSend(email: _emailController.text);
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget _buildButtonSend({String email}) {
    return FlatButton(
      child: Text("Recuperar senha", style: TextStyle(color: Colors.white, fontSize: 18),),
      color: Theme.of(context).hintColor,
      textColor: Colors.white,
      onPressed: () {
        loginBloc.doRecoverPassword.add(email);
      },
    );
  }
}
