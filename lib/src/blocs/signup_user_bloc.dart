import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

enum SignupState { IDLE, LOADING, SUCCESS, FAIL, ERROR_EMAIL }

class SignupUserBloc extends BlocBase {

  UserProviderModel _model;

  //CONTROLLERS
  final _singupController = BehaviorSubject<Map<String, dynamic>>();
  final _stateController = BehaviorSubject<SignupState>();
  final _emailController = BehaviorSubject<String>();

  //STREAMS
  Stream<Map<String, dynamic>> get outSignup => _singupController.stream;
  Stream<SignupState> get outState => _stateController.stream;
  Stream<String> get outEmail => _emailController.stream;

  //SINKS
  Sink<Map<String, dynamic>> get doSignUp => _singupController.sink;
  Function(String) get changeEmail => _emailController.sink.add;

  SignupUserBloc(model) {
    _model= model;
    _singupController.stream.listen(_signupFirebase);
  }

  void _signupFirebase(Map<String, dynamic> data) async {
    if (data != null) {
      _stateController.add(SignupState.LOADING);

      FirebaseAuth _auth = FirebaseAuth.instance;

      try {

        //Tenta criar o usuário novo com email e senha
        await _auth.createUserWithEmailAndPassword(
            email: data['email'], password: data['password']);

        //Envia um email de confirmação de conta
        await _model.userFirebase.sendEmailVerification();

        _model.notifyListeners();

      } catch (e) {
        if (e.code.toString() == "ERROR_EMAIL_ALREADY_IN_USE") {
          _emailController.addError("Esse email já está sendo usado.");
        }

        _stateController.add(SignupState.FAIL);

        return;
      }

      data.remove('password');

      data.putIfAbsent('profileCompleted', () => false);
      data.putIfAbsent('rating', () => 0.0);

      FirebaseUser user = await _auth.currentUser();
      await Firestore.instance
          .collection("users")
          .document(user.uid)
          .setData(data);

      _stateController.add(SignupState.SUCCESS);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _singupController.close();
    _stateController.close();
    _emailController.close();
  }
}
