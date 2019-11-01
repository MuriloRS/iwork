import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/home_screen_company.dart';
import 'package:contratacao_funcionarios/src/screens/user_screens/home_screen_user.dart';
import 'package:contratacao_funcionarios/src/shared/alerts.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailConfirmationScreen extends StatelessWidget {
  UserBloc _userBloc;
  int typeUser;
  UserModel model;
  FirebaseAuth auth = FirebaseAuth.instance;

  EmailConfirmationScreen({@required this.typeUser});

  @override
  Widget build(BuildContext context) {
    model = Provider.of<UserModel>(context);

    _userBloc = UserBloc();

    return Material(
        child: SafeArea(
            child: StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState.index == ConnectionState.none.index ||
            snapshot.connectionState.index == ConnectionState.waiting.index) {
          return Loader();
        } else if (snapshot.data.isEmailVerified) {
          if (this.typeUser == 1) {
            return HomeScreenUser(2);
          } else {
            return HomeScreenCompany(2);
          }
        } else {
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
                  color: Theme.of(context).primaryColor),
            ),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              dynamic currentUser = await _userBloc.currentUser();
              model.ofMap(currentUser);
              model.notifyListeners();

              await _userBloc.verifyEmailConfirmed();
            },
          )
        ],
      ),
    ));
  }
}
