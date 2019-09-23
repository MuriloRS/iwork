import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProviderModel extends ChangeNotifier{
  Map userData;
  FirebaseUser userFirebase;

  String getUserSkills(){
    return userData['skills'].toString().replaceAll('[', '').replaceAll(']', '');
  }

}