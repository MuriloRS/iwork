import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL, USER_NOT_VERIFIED }
enum TypeUser { COMPANY, USER, NOT_CONFIRMED }

class LoginBloc extends BlocBase {
  FirebaseAuth _auth = FirebaseAuth.instance;
  BuildContext context;

  //CONTROLLERS
  var _loginController = BehaviorSubject<UserModel>();
  var _stateController = BehaviorSubject<LoginState>();
  var _typeUserController = BehaviorSubject<TypeUser>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //STREAMS
  Stream<UserModel> get outLogin => _loginController.stream;
  Stream<LoginState> get outState => _stateController.stream;
  Stream<TypeUser> get outTypeUser => _typeUserController.stream;
  Stream<String> get outEmail => _emailController.stream;
  Stream<String> get outPassword => _passwordController.stream;

  //SINKS
  Sink<UserModel> get doLogin => _loginController.sink;
  Sink<TypeUser> get doTypeUser => _typeUserController.sink;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  LoginBloc(context) {
    this.context = context;
    _loginController.stream.listen(_executeLogin);
  }

  void _executeLogin(UserModel user) async {
    _stateController.add(LoginState.LOADING);

    AuthResult _userAuth;
    try {
      _userAuth = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.senha);

      UserModel userModel = Provider.of<UserModel>(context);

      Map<String, dynamic> userData = await new UserBloc().currentUser();

      userModel.ofMap(userData['userData']
      );
      userModel.notifyListeners();

      if (!(userData['userFirebase'] as FirebaseUser).isEmailVerified) {
        _typeUserController.add(TypeUser.NOT_CONFIRMED);
        _stateController.add(LoginState.FAIL);
      } else {
        if (userData['userData']['isCompany']) {
          _typeUserController.add(TypeUser.COMPANY);
        } else {
          _typeUserController.add(TypeUser.USER);
        }
        _stateController.add(LoginState.FAIL);
      }

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

  void googleSignIn() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    GoogleSignInAccount account;

    try {
      account = await _googleSignIn.signIn();

      UserModel userModel = Provider.of<UserModel>(context);
      userModel.ofMap({
        'identificador': '',
        'curriculum': '',
        'email': account.email,
        'isCompany': false,
        'name': '',
        'rating': '0',
        'senha': '',
      });

      userModel.notifyListeners();

      await Firestore.instance.collection('users').add(userModel.toMap());

      _typeUserController.add(TypeUser.USER);
      _stateController.add(LoginState.SUCCESS);
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _loginController.close();
    _stateController.close();
    _emailController.close();
    _passwordController.close();
    _typeUserController.close();
  }
}
