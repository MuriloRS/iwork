import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String name,
      email,
      senha,
      identificador,
      curriculum,
      telephone,
      city,
      rating,
      documentId;
  bool isCompany, profileCompleted;
  List<dynamic> skills = List();

  UserModel(
      {this.identificador,
      this.documentId,
      this.skills,
      this.email,
      this.city,
      this.name,
      this.senha,
      this.isCompany,
      this.curriculum,
      this.profileCompleted,
      this.rating,
      this.telephone});

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'identificador': this.identificador,
      'isCompany': this.isCompany,
      'telephone': this.telephone,
      'profileCompleted': this.profileCompleted,
      'city': this.city,
      'rating': '0',
      'curriculum': this.curriculum,
      'skills': this.skills,
      'documentId': this.documentId
    };
  }

  void ofMap(Map<String, dynamic> user) {
    this.name = user['name'];
    this.documentId = user['documentId'];
    this.identificador = user['identificador'];
    this.email = user['email'];
    this.city = user['city'];
    this.senha = user['senha'];
    this.isCompany = user['isCompany'];
    this.curriculum = user['curriculum'];
    this.profileCompleted = user['profileCompleted'];
    this.rating = user['rating'];
    this.telephone = user['telephone'];
    this.skills = user['skills'];
  }

  void clear() {
    this.name = null;
    this.documentId = null;
    this.identificador = null;
    this.email = null;
    this.city = null;
    this.senha = null;
    this.isCompany = null;
    this.curriculum = null;
    this.profileCompleted = null;
    this.rating = null;
    this.telephone = null;
    this.skills = null;
    ;
  }
}
