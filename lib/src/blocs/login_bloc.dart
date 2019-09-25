import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:contratacao_funcionarios/src/models/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL, USER_NOT_VERIFIED }

class LoginBloc extends BlocBase with LoginValidators {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //CONTROLLERS
  var _loginController = BehaviorSubject<UserModel>();
  var _stateController = BehaviorSubject<LoginState>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //STREAMS
  Stream<UserModel> get outLogin => _loginController.stream;
  Stream<LoginState> get outState => _stateController.stream;
  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  //SINKS
  Sink<UserModel> get doLogin => _loginController.sink;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  LoginBloc() {
    _loginController.stream.listen(_executeLogin);
  }

  void _executeLogin(UserModel user) async {
    _stateController.add(LoginState.LOADING);

    AuthResult _userAuth;
    try {
      _userAuth = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.senha);

      _stateController.add(LoginState.SUCCESS);
    } catch (e) {
      if (e.code == "ERROR_WRONG_PASSWORD") {
        _passwordController.addError("Senha incorreta, tente novamente");
      }

      if (e.code == "ERROR_USER_NOT_FOUND") {
        _emailController.addError("Email não encontrado.");
      }

      _stateController.add(LoginState.FAIL);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _loginController.close();
    _stateController.close();
    _emailController.close();
    _passwordController.close();
  }
}
