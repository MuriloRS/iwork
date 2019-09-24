import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/login_page.dart';
import 'package:contratacao_funcionarios/src/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DrawerUser extends StatelessWidget {
  final PageController pageController;
  UserProviderModel _model;
  UserBloc _bloc;

  DrawerUser(this.pageController);

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<UserProviderModel>(context);
    _bloc = new UserBloc(_model);

    return Drawer(
        child: Column(
      children: <Widget>[
        Container(
            color: Colors.white,
            height: 120.0,
            width: double.infinity,
            padding: EdgeInsets.only(right: 25, left: 25, top: 25, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Busca Emprego",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(_model.userData['name'],
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 18))
              ],
            )),
        Divider(
          height: 1,
          color: Colors.grey[400],
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Column(
            children: <Widget>[
              DrawerTile(FontAwesomeIcons.home, "Início", pageController, 0),
              DrawerTile(FontAwesomeIcons.question, "Como Funciona",
                  pageController, 1),
              DrawerTile(FontAwesomeIcons.user, "Conta", pageController, 2),
              DrawerTile(
                  FontAwesomeIcons.envelope, "Contato", pageController, 3),
              DrawerTile(FontAwesomeIcons.fileSignature, "Termos e Condições",
                  pageController, 4),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              child: Text(
                "Sair",
                style: TextStyle(
                    color: Colors.black, decoration: TextDecoration.underline),
              ),
              onPressed: () {

                _bloc.signout();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ),
        )
      ],
    ));
  }
}
