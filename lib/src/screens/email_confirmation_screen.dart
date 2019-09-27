import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/home_screen_company.dart';
import 'package:contratacao_funcionarios/src/screens/user_screens/home_screen_user.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailConfirmationScreen extends StatelessWidget {
  UserBloc _userBloc;
  int typeUser;
  UserProviderModel model;

  EmailConfirmationScreen({@required this.typeUser});

  @override
  Widget build(BuildContext context) {
    model = Provider.of<UserProviderModel>(context);

    _userBloc = UserBloc(model);

    return Material(
        child: SafeArea(
            child: StreamBuilder(
      stream: _userBloc.outState,
      builder: (context, AsyncSnapshot<UserState> snapshot) {
          switch (snapshot.data) {
            case UserState.LOADING:
              return Loader();
              break;
            case UserState.USER_VERIFIED:
              if (typeUser == 1) {
                return HomeScreenUser();
              } else {
                return HomeScreenCompany();
              }

              break;
            case UserState.SUCCESS:
              return SnackBar(
                content: Text("Email enviado"),
                duration: Duration(seconds: 5),
              );
            default:
              return _buildBody(context);
          }
        
      },
    )));
  }

  Widget _buildBody(context) {
    return Center(
        child: Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Te enviamos um e-mail para você confirmar seu e-mail, verifique sua caixa de spam.",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          CupertinoButton(
            child: Text(
              "Re-enviar",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor),
            ),
            color: Colors.grey[200],
            onPressed: () {
              _userBloc.sendEmailVerification();
            },
          ),
          SizedBox(
            height: 15,
          ),
          CupertinoButton(
            child: Text(
              "Confirmei",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green),
            ),
            color: Colors.grey[200],
            onPressed: () async {
              await model.userFirebase.reload();
              _userBloc.verifyEmailConfirmed();
            },
          )
        ],
      ),
    ));
  }
}
