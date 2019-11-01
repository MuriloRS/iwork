import 'dart:convert';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

enum AccountUserState { IDLE, LOADING, SUCCESS, FAIL }

class AccountUserBloc extends BlocBase {
  File curriculum;

  //CONTROLLERS
  final stateController = BehaviorSubject<AccountUserState>();
  final stateCitiesController = BehaviorSubject<AccountUserState>();
  final nameController = BehaviorSubject<String>();
  final skillsController = BehaviorSubject<String>();
  final citiesController = BehaviorSubject<String>();
  final telephoneController = BehaviorSubject<String>();
  final curriculumController = BehaviorSubject<String>();
  final saveController = BehaviorSubject<Map<String,dynamic> >();

  //STREAMS
  Stream<AccountUserState> get outState => stateController.stream;
  Stream<AccountUserState> get outStateCities => stateCitiesController.stream;
  Stream<String> get outName => nameController.stream;
  Stream<String> get outSkills => skillsController.stream;
  Stream<String> get outCities => citiesController.stream;
  Stream<String> get outCurriculum => curriculumController.stream;
  Stream<String> get outTelephone => telephoneController.stream;
  Stream<Map<String,dynamic> > get outSave => saveController.stream;

  //SINKS
  Function(String) get changeSkills => skillsController.sink.add;
  Function(String) get changeName => nameController.sink.add;
  Function(String) get changeCities => citiesController.sink.add;
  Function(String) get changeCurriculum => curriculumController.sink.add;
  Function(String) get changeTelephone => telephoneController.sink.add;
  Sink<Map<String,dynamic> > get changeSave => saveController.sink;

  AccountUserBloc() {
    saveController.listen(_saveAccountDetail);
  }

  Future<List<String>> getCities(context) async {
    stateCitiesController.add(AccountUserState.LOADING);

    List<String> listCities = new List();

    try {
      String result = await DefaultAssetBundle.of(context)
          .loadString('lib/src/shared/municipios.json');

      final parsed =
          json.decode(result.toString()).cast<Map<String, dynamic>>();

      parsed.forEach((m) => listCities.add(m['nome']));

      stateCitiesController.add(AccountUserState.SUCCESS);
    } catch (e) {
      stateCitiesController.add(AccountUserState.FAIL);
    }

    return listCities;
  }

  _saveAccountDetail(Map<String,dynamic> user) async {
    stateController.add(AccountUserState.LOADING);

    try {
      //VALIDAÇÃO DOS CAMPOS OBRIGATÓRIOS
      if (user['name'] == null || user['name'] == '') {
        nameController.addError("O campo nome é obrigatório");
        stateController.add(AccountUserState.FAIL);

        return;
      }
      if (user['city'] == null || user['city'] == '') {
        citiesController.addError("O campo cidade é obrigatório");
        stateController.add(AccountUserState.FAIL);
        return;
      }

      //Se for usuário comum então o telefone é obrigatório
      if (!user['isCompany']) {
        if (user['telephone'] == null || user['telephone'] == '') {
          telephoneController.addError("O campo telefone é obrigatório");
          stateController.add(AccountUserState.FAIL);
          return;
        }
      }
      user['profileCompleted'] = true;

      if (this.curriculum != null) {
        user['curriculum'] = p.basename(this.curriculum.path);

        FirebaseStorage.instance
            .ref()
            .child(user['documentId'] + "/" + user['curriculum'])
            .putFile(this.curriculum);
      } else {
        if (user['curriculum'] != '' && !user['isCompany']) {
          await FirebaseStorage.instance
              .ref()
              .child(user['documentId'] + "/" + user['documentId'])
              .delete();
        }

        user['curriculum'] = '';
      }

      await Firestore.instance
          .collection("users")
          .document(user['documentId'])
          .setData(user);

      stateController.add(AccountUserState.SUCCESS);
    } catch (e) {
      stateController.add(AccountUserState.FAIL);
    }
  }

  void openPdf(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void deleteCurriculum(Map<String,dynamic> model) {
    curriculum = null;

    _saveAccountDetail(model);
  }

  @override
  void dispose() {
    super.dispose();

    nameController.close();
    skillsController.close();
    citiesController.close();
    stateController.close();
    curriculumController.close();
    saveController.close();
    stateCitiesController.close();
    telephoneController.close();
  }
}
