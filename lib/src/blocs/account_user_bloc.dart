import 'dart:convert';
import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

enum AccountUserState { IDLE, LOADING, SUCCESS, FAIL }

class AccountUserBloc extends BlocBase {
  //CONTROLLERS
  final stateController = BehaviorSubject<AccountUserState>();
  final nameController = BehaviorSubject<String>();
  final skillsController = BehaviorSubject<String>();
  final citiesController = BehaviorSubject<String>();
  final curriculumController = BehaviorSubject<String>();
  final saveController = BehaviorSubject<UserProviderModel>();

  //STREAMS
  Stream<AccountUserState> get outState => stateController.stream;
  Stream<String> get outName => nameController.stream;
  Stream<String> get outSkills => skillsController.stream;
  Stream<String> get outCities => citiesController.stream;
  Stream<String> get outCurriculum => curriculumController.stream;
  Stream<UserProviderModel> get outSave => saveController.stream;

  //SINKS
  Function(String) get changeSkills => skillsController.sink.add;
  Function(String) get changeName => nameController.sink.add;
  Function(String) get changeCities => citiesController.sink.add;
  Function(String) get changeCurriculum => curriculumController.sink.add;
  Sink<UserProviderModel> get changeSave => saveController.sink;

  AccountUserBloc() {
    saveController.listen(_saveAccountDetail);
  }

  Future<List<String>> getCities(context) async {
    stateController.add(AccountUserState.LOADING);

    List<String> listCities = new List();

    try {
      String result = await DefaultAssetBundle.of(context)
          .loadString('lib/src/shared/municipios.json');

      final parsed =
          json.decode(result.toString()).cast<Map<String, dynamic>>();

      parsed.forEach((m) => listCities.add(m['nome']));

      stateController.add(AccountUserState.SUCCESS);
    } catch (e) {
      stateController.add(AccountUserState.FAIL);
    }

    return listCities;
  }

  _saveAccountDetail(UserProviderModel user) {
    stateController.add(AccountUserState.LOADING);

    try {
      
      //VALIDAÇÃO DOS CAMPOS OBRIGATÓRIOS
      if(user.userData['name'] == null || user.userData['name'] == ''){
        nameController.addError("O campo nome é obrigatório");
        stateController.add(AccountUserState.FAIL);
      }
      if(user.userData['city'] == null || user.userData['city'] == ''){
        citiesController.addError("O campo cidade é obrigatório");
        stateController.add(AccountUserState.FAIL);
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

  @override
  void dispose() {
    super.dispose();

    nameController.close();
    skillsController.close();
    citiesController.close();
    stateController.close();
    curriculumController.close();
    saveController.close();
  }
}
