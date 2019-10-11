import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

enum RecoverPasswordState { IDLE, LOADING, SUCCESS, FAIL }

class RecoverPasswordBloc extends BlocBase {
  FirebaseAuth _auth = FirebaseAuth.instance;

  //CONTROLLERS
  var _recoverPasswordController = BehaviorSubject<String>();
  var _stateController = BehaviorSubject<RecoverPasswordState>();
  final _emailController = BehaviorSubject<String>();

  //STREAMS
  Stream<String> get outLogin => _recoverPasswordController.stream;
  Stream<RecoverPasswordState> get outState => _stateController.stream;
  Stream<String> get outEmail => _emailController.stream;

  //SINKS
  Sink<String> get doRecoverPassword => _recoverPasswordController.sink;
  Function(String) get changeEmail => _emailController.sink.add;

  RecoverPasswordBloc() {
    _recoverPasswordController.stream.listen(_recoverPassword);
  }

  void _recoverPassword(String email) async {
    _stateController.add(RecoverPasswordState.LOADING);

    try {
      await _auth.sendPasswordResetEmail(email: email);

      _stateController.add(RecoverPasswordState.SUCCESS);
    } catch (e) {
      _emailController.addError("Email inválido");
      _stateController.add(RecoverPasswordState.FAIL);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _stateController.close();
    _emailController.close();
    _recoverPasswordController.close();
  }
}
