import 'dart:convert';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
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
  final saveController = BehaviorSubject<UserProviderModel>();

  //STREAMS
  Stream<AccountUserState> get outState => stateController.stream;
  Stream<AccountUserState> get outStateCities => stateController.stream;
  Stream<String> get outName => nameController.stream;
  Stream<String> get outSkills => skillsController.stream;
  Stream<String> get outCities => citiesController.stream;
  Stream<String> get outCurriculum => curriculumController.stream;
  Stream<String> get outTelephone => telephoneController.stream;
  Stream<UserProviderModel> get outSave => saveController.stream;

  //SINKS
  Function(String) get changeSkills => skillsController.sink.add;
  Function(String) get changeName => nameController.sink.add;
  Function(String) get changeCities => citiesController.sink.add;
  Function(String) get changeCurriculum => curriculumController.sink.add;
  Function(String) get changeTelephone => telephoneController.sink.add;
  Sink<UserProviderModel> get changeSave => saveController.sink;

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

  _saveAccountDetail(UserProviderModel user) {
    stateController.add(AccountUserState.LOADING);

    try {
      //VALIDAÇÃO DOS CAMPOS OBRIGATÓRIOS
      if (user.userData['name'] == null || user.userData['name'] == '') {
        nameController.addError("O campo nome é obrigatório");
        stateController.add(AccountUserState.FAIL);

        return;
      }
      if (user.userData['city'] == null || user.userData['city'] == '') {
        citiesController.addError("O campo cidade é obrigatório");
        stateController.add(AccountUserState.FAIL);
        return;
      }

      if (user.userData['telephone'] == null || user.userData['telephone'] == '') {
        telephoneController.addError("O campo telefone é obrigatório");
        stateController.add(AccountUserState.FAIL);
        return;
      }

      user.userData['profileCompleted'] = true;

      if (this.curriculum != null) {
        user.userData['curriculum'] = p.basename(this.curriculum.path);
        final StorageReference storageRef = FirebaseStorage.instance
            .ref()
            .child(
                user.userFirebase.uid + "/" + p.basename(this.curriculum.path));

        final StorageUploadTask uploadTask = storageRef.putFile(
          File(this.curriculum.path),
        );
      } else {
        if (user.userData['curriculum'] != '') {
          FirebaseStorage.instance
              .ref()
              .child(user.userFirebase.uid + "/" + user.userData['curriculum'])
              .delete();
        }

        user.userData['curriculum'] = '';
      }

      Firestore.instance
          .collection("users")
          .document(user.userFirebase.uid)
          .updateData(user.userData);

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

  void deleteCurriculum(UserProviderModel model) {
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
