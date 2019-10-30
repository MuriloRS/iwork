import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';

import 'package:contratacao_funcionarios/src/shared/alerts.dart';

import 'package:contratacao_funcionarios/src/widgets/professional_tile.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

enum StateCurrent { IDLE, LOADING, SUCCESS, FAIL, EMPTY }

class CompanyBloc extends BlocBase {
  final stateController = BehaviorSubject<StateCurrent>();
  final searchProfessionalController = BehaviorSubject<Map<String, dynamic>>();
  String docCompany;

  Stream<StateCurrent> get outState => stateController.stream;
  Stream<Map<String, dynamic>> get outSearchProfessional =>
      searchProfessionalController.stream;

  Sink<Map<String, dynamic>> get doSearchProfessional =>
      searchProfessionalController.sink;

  List<Widget> listProfessionals;

  CompanyBloc(docCompany) {
    searchProfessionalController.stream.listen(searchProfessionals);
    this.docCompany = docCompany;
  }

  Future<QuerySnapshot> searchProfessionalContracts(idProfessional) async {
    return await Firestore.instance
        .collection('contracts')
        .where('professional', isEqualTo: idProfessional)
        .where('status', isEqualTo: 'FINALIZADO')
        .getDocuments();
  }

  void searchProfessionals(params) async {
    stateController.add(StateCurrent.LOADING);
    QuerySnapshot snapshot;

    snapshot = await Firestore.instance
        .collection('users')
        .where('isCompany', isEqualTo: false)
        .where('profileCompleted', isEqualTo: true)
        .getDocuments();

    List<Widget> list = new List();
    snapshot.documents.asMap().forEach((index, doc) {
      if (params['rating'] != null && params['funcao'] != null) {
        if (doc.data['rating'] >= params['rating'] &&
            (doc.data['skills'] as List).contains(params['funcao'])) {
          list.add(ProfessionalTile(doc, params['nameCompany']));
        }
      } else if (params['rating'] != null) {
        if (double.parse(doc.data['rating']) >= params['rating']) {
          list.add(ProfessionalTile(doc, params['nameCompany']));
        }
      } else if (params['funcao'] != null) {
        if ((doc.data['skills'] as List).contains(params['funcao'])) {
          list.add(ProfessionalTile(doc, params['nameCompany']));
        }
      } else {
        list.add(ProfessionalTile(doc, params['nameCompany']));
      }
    });
    if (list.length == 0) {
      stateController.add(StateCurrent.EMPTY);
    } else {
      listProfessionals = list;
      stateController.add(StateCurrent.SUCCESS);
    }
  }

  buildAlertSendContract(context, DocumentSnapshot doc, String nameCompany) {
    Navigator.of(context).pop();

    Alerts.dialogFilter(context, this, doc, docCompany);
  }

  void saveNewContract(
      {@required String role,
      @required String docProfessional,
      @required String docCompany,
      @required String valorTotal,
      @required DateTime dataInicio,
      @required DateTime horaInicio,
      @required String duracao,
      @required String name,
      @required BuildContext context}) async {
    double valor = double.parse(valorTotal
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll(',', '.')
        .toString());

    DateTime newDate = DateTime(dataInicio.year, dataInicio.month,
        dataInicio.day, horaInicio.hour, horaInicio.minute);

    await Firestore.instance.collection('contracts').add({
      'role': role,
      'totalValue': valor,
      'dataInicio': newDate,
      'duracao': duracao,
      'professional': docProfessional,
      'company': docCompany,
      'nameProfessional': name,
      'rating': '0',
      'status': 'PENDENTE'
    });

    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 15),
      content: Text(
          "O contrato foi enviado para o Profissional, agora é só aguardar ele aceitar, se prefereir pode ligar para ele para agilizar o processo.",
          textAlign: TextAlign.center),
    ));
  }

  void updateRatingContract(contractId, newRating) async {
    await Firestore.instance
        .collection('contracts')
        .document(contractId)
        .updateData({'ratingCompany': newRating.toString()});
  }

  dynamic searchProfessionalCurriculum(documentId, curriculum){
    return new UserBloc().getCurriculumUser(curriculum, documentId);
  }

  Future<QuerySnapshot> searchCompanyContracts(idCompany) async {
    return await Firestore.instance
        .collection('contracts')
        .where('company', isEqualTo: idCompany)
        .getDocuments();
  }

  @override
  void dispose() {
    super.dispose();
    searchProfessionalController.close();
    stateController.close();
  }
}
