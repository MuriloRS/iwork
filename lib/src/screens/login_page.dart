import 'package:contratacao_funcionarios/src/blocs/login_bloc.dart';
import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/home_screen_company.dart';
import 'package:contratacao_funcionarios/src/screens/email_confirmation_screen.dart';
import 'package:contratacao_funcionarios/src/screens/recover_screen.dart';
import 'package:contratacao_funcionarios/src/screens/signup_user_page.dart';
import 'package:contratacao_funcionarios/src/screens/user_screens/home_screen_user.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:contratacao_funcionarios/src/widgets/navigator_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  UserBloc _userBloc = UserBloc();
  UserProviderModel _model;
  Future<Map<String, dynamic>> futureCurrentUser;

  Widget _formLogin;

  @override
  void initState() {
    super.initState();
    futureCurrentUser = _userBloc.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<UserProviderModel>(context);
    _loginBloc = LoginBloc(context);

    void _listenState() {
      _loginBloc.outTypeUser.listen((state) async {
        switch (state) {
          case TypeUser.COMPANY:
            Navigator.of(context).pushReplacement(
                NavigatorAnimation(widget: HomeScreenCompany()));

            break;

          case TypeUser.USER:
            Navigator.of(context)
                .pushReplacement(NavigatorAnimation(widget: HomeScreenUser()));
            break;
          case TypeUser.NOT_CONFIRMED:
            Navigator.of(context).pushReplacement(NavigatorAnimation(
                widget: EmailConfirmationScreen(
              typeUser: _userBloc.userData['isCompany'],
            )));
            break;
          default:
            return Container();
        }

        return Container();
      });
    }

    Widget _getButtonLogin(fbKey) {
      return FlatButton(
        child: Text(
          "ENTRAR",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
        padding: EdgeInsets.all(10),
        color: Theme.of(context).accentColor,
        onPressed: () {
          if (fbKey.currentState.validate()) {
            UserModel user = new UserModel(
                email: fbKey.currentState.fields['Emaile'].currentState.value,
                senha: fbKey.currentState.fields['Senhae'].currentState.value);

            _listenState();

            _loginBloc.doLogin.add(user);
          }
        },
      );
    }

    FormBuilder _buildForm() {
      final fbKey = GlobalKey<FormBuilderState>();

      return FormBuilder(
        key: fbKey,
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Image.asset('images/logo3.png'),
                      height: 110,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InputField(
                        null,
                        false,
                        TextInputType.emailAddress,
                        'Email',
                        [
                          FormBuilderValidators.required(
                              errorText: 'O e-mail é obrigatório'),
                          FormBuilderValidators.email(
                              errorText: "Formato de email inválido"),
                          FormBuilderValidators.max(40),
                        ],
                        _loginBloc.outEmail,
                        _loginBloc.changeEmail,
                        "Emaile",
                        true),
                    SizedBox(
                      height: 5,
                    ),
                    InputField(
                        null,
                        true,
                        TextInputType.text,
                        'Senha',
                        [
                          FormBuilderValidators.required(
                              errorText: 'O campo senha é obrigatório'),
                          FormBuilderValidators.min(5,
                              errorText:
                                  "A senha deve ter no minímo 5 caracteres."),
                          FormBuilderValidators.max(40,
                              errorText:
                                  "A senha deve ter no máximo 40 caracteres."),
                        ],
                        _loginBloc.outPassword,
                        _loginBloc.changePassword,
                        'Senhae',
                        true),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: StreamBuilder(
                        stream: _loginBloc.outState,
                        builder: (context, AsyncSnapshot<LoginState> snapshot) {
                          switch (snapshot.data) {
                            case LoginState.IDLE:
                              return Container();
                              break;

                            case LoginState.LOADING:
                              return Loader();

                              break;
                            default:
                              return _getButtonLogin(fbKey);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      child: Text(
                        "Esqueceu sua senha?",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15.0,
                            color: Theme.of(context).cardColor),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            NavigatorAnimation(widget: RecoverScreen()));
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Entrar com o Facebook",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.all(
                        Radius.circular(30),
                      )),
                      color: Color.fromRGBO(60, 90, 153, 1),
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("images/google_icon.png"),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Entrar com o Google",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: Colors.white,
                      shape: new RoundedRectangleBorder(
                          side: new BorderSide(color: Colors.grey[300]),
                          borderRadius: new BorderRadius.all(
                            Radius.circular(30),
                          )),
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text("Ainda não tem uma conta?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).cardColor)),
                          FlatButton(
                            color: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Cadastrar",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14.0,
                                  color: Theme.of(context).hintColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(NavigatorAnimation(
                                  widget: CadastroClientePage()));
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
      );
    }

    if (_formLogin == null) {
      _formLogin = _buildForm();
    }

    return Scaffold(
        body: FutureBuilder(
      future:
          Future.wait([futureCurrentUser, FirebaseAuth.instance.currentUser()]),
      builder: (context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.connectionState.index == ConnectionState.none.index ||
            snapshot.connectionState.index == ConnectionState.waiting.index) {
          return Loader();
        }
        _model.userData = snapshot.data.elementAt(0);
        _model.userFirebase = snapshot.data.elementAt(1);
        if (snapshot.data == null) {
          _userBloc.isLoggedIn = false;
        } else {
          _userBloc.isLoggedIn = true;
        }
        if (_model.userData != null && _userBloc.isLoggedIn) {
          if (_model.userData['isCompany'] == true) {
            return HomeScreenCompany();
          } else {
            return HomeScreenUser();
          }
        } else {
          return _buildForm();
        }
      },
    ));
  }
}
