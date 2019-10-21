import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/widgets/historic_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
  bool isLoggedIn;

  final _stateController = BehaviorSubject<UserState>();

  Stream<UserState> get outState => _stateController.stream;

  UserBloc() {
    _auth = FirebaseAuth.instance;
  }

  Future<Map<String, dynamic>> currentUser() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      userData = await _getUserData(user.uid);

      return userData;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUserContracts(userId) async {
    List<Map<String, dynamic>> listContracts = List();
    QuerySnapshot contracts = await Firestore.instance
        .collection('contracts')
        .where('professional', isEqualTo: userId)
        .getDocuments();

    for (int x = 0; x < contracts.documents.length - 1; x++) {
      DocumentSnapshot company = await Firestore.instance
          .collection('users')
          .document(contracts.documents.elementAt(x).data['company'])
          .get();

      contracts.documents.elementAt(x).data['companyName'] =
          company.data['name'];
      listContracts.add(contracts.documents.elementAt(x).data);
    }

    return listContracts;
  }

  String getUserSkills(userData) {
    return userData['skills']
        .toString()
        .trim()
        .replaceAll(',', ', ')
        .replaceAll('[', '')
        .replaceAll(']', '');
  }

  void signout() async {
    await FirebaseAuth.instance.signOut();
  }

  dynamic getCurriculumUser(String curriculumName) async {
    if (curriculumName == '') {
      return '';
    }

    StorageReference reference =
        FirebaseStorage.instance.ref().child(_user.uid + "/$curriculumName");

    dynamic url;

    try {
      url = await reference.getDownloadURL();
    } catch (e) {}

    return url;
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
    DocumentSnapshot snapshot;

    snapshot = await Firestore.instance.collection("users").document(uid).get();
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
