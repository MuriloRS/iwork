import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/subjects.dart';

enum UserState {
  IDLE,
  LOADING,
  SUCCESS,
  FAIL,
  USER_VERIFIED,
  USER_NOT_VERIFIED
}

class UserBloc extends BlocBase {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Map userData;
  UserProviderModel _model;

  final _stateController = BehaviorSubject<UserState>();

  Stream<UserState> get outState => _stateController.stream;

  UserBloc(model) {
    _model = model;
    _auth = FirebaseAuth.instance;
  }

  Future<void> currentUser() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      userData = await _getUserData(user.uid);

      _model.userData = userData;
      _model.userFirebase = user;
    }
  }

  verifyEmailConfirmed() async {
    _stateController.add(UserState.LOADING);

    FirebaseUser user = await _auth.currentUser();

    await user.reload();

    if (user.isEmailVerified) {
      _stateController.add(UserState.USER_VERIFIED);
    } else {
      _stateController.add(UserState.FAIL);
    }
  }

  Future<Map> _getUserData(uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("users").document(uid).get();

    return snapshot.data;
  }

  sendEmailVerification() async {
    _stateController.add(UserState.LOADING);

    try {
      _user = await _auth.currentUser();

      await _user.sendEmailVerification();

      _stateController.add(UserState.SUCCESS);
    } catch (e) {
      _stateController.add(UserState.FAIL);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _stateController.close();
  }
}
