import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
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
  final saveController = BehaviorSubject<Map>();

  //STREAMS
  Stream<AccountUserState> get outState => stateController.stream;
  Stream<String> get outName => nameController.stream;
  Stream<String> get outSkills => skillsController.stream;
  Stream<String> get outCities => citiesController.stream;
  Stream<String> get outCurriculum => curriculumController.stream;
  Stream<Map> get outSave => saveController.stream;

  //SINKS
  Function(String) get changeSkills => skillsController.sink.add;
  Function(String) get changeName => nameController.sink.add;
  Function(String) get changeCities => citiesController.sink.add;
  Function(String) get changeCurriculum => curriculumController.sink.add;
  Sink<Map> get changeSave => saveController.sink;

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

  _saveAccountDetail(map){
    if(""== ""){

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
