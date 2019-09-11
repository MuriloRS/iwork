import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProviderModel extends ChangeNotifier{
  Map userData;
  FirebaseUser userFirebase;
/*
  void setUserData(Map userData){
    this._userData = userData;
  }

  void setUserFirebase(FirebaseUser firebaseUser){
    this._userFirebase = firebaseUser;
  }

  Map getUserData(){
    return this._userData;
  }

  FirebaseUser getUserFirebase(){
    return this._userFirebase;
  }*/

}