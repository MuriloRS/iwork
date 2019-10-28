import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/user_detail_screen.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/home_company_tab.dart';
import 'package:contratacao_funcionarios/src/shared/alerts.dart';
import 'package:contratacao_funcionarios/src/shared/currency_input_formatter.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:contratacao_funcionarios/src/widgets/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swipe_stack/swipe_stack.dart';

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

  List<SwiperItem> listProfessionals;

  CompanyBloc(docCompany) {
    searchProfessionalController.stream.listen(searchProfessionals);
    this.docCompany = docCompany;
  }

  Future<QuerySnapshot> searchProfessionalContracts(idProfessional) async {
    return await Firestore.instance
        .collection('contracts')
        .where('professionalId', isEqualTo: idProfessional)
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

    List<SwiperItem> list = new List();
    snapshot.documents.asMap().forEach((index, doc) {
      if (params['rating'] != null && params['funcao'] != null) {
        if (doc.data['rating'] >= params['rating'] &&
            (doc.data['skills'] as List).contains(params['funcao'])) {
          list.add(_buildSwiperItem(params['context'], doc));
        }
      } else if (params['rating'] != null) {
        if (double.parse(doc.data['rating']) >= params['rating']) {
          list.add(_buildSwiperItem(params['context'], doc));
        }
      } else if (params['funcao'] != null) {
        if ((doc.data['skills'] as List).contains(params['funcao'])) {
          list.add(_buildSwiperItem(params['context'], doc));
        }
      } else {
        list.add(_buildSwiperItem(params['context'], doc));
      }
    });
    if (list.length == 0) {
      stateController.add(StateCurrent.EMPTY);
    } else {
      listProfessionals = list;
      stateController.add(StateCurrent.SUCCESS);
    }
    
  }

  SwiperItem _buildSwiperItem(context, DocumentSnapshot document) {
    final TextStyle styleDefault =
        TextStyle(fontSize: 18, fontWeight: FontWeight.w400);

    return SwiperItem(builder: (SwiperPosition pos, double progress) {
      return Material(
          elevation: 5,
          child: Container(
              height: MediaQuery.of(context).size.height - 280,
              width: MediaQuery.of(context).size.width - 40,
              child: Container(
                  padding:
                      EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("Avaliação: ", style: styleDefault),
                            RatingBar(
                              initialRating:
                                  double.parse(document.data['rating']),
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemSize: 18,
                              itemCount: 5,
                              unratedColor: Colors.grey[350],
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Nome: ${document.data['name']} ",
                            style: styleDefault),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Email: ${document.data['email']} ",
                            style: styleDefault),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Telefone: ${document.data['telephone']} ",
                            style: styleDefault),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Cidade: ${document.data['city']}",
                            style: styleDefault),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            "Funções:" +
                                ((document.data['skills'] as List).length > 0
                                    ? document.data['skills']
                                        .toString()
                                        .replaceAll('[]', '')
                                        .toString()
                                    : " Sem experiência"),
                            style: styleDefault),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: ButtonInput.getButton(TYPE_BUTTON.OUTLINE,
                                COLOR_BUTTON.DEFAULT, 'Ver mais', () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetailScreen(document)));
                            }, context, null, 15)),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              FlatButton(
                                color: Theme.of(context).hintColor,
                                child: Text('Propor Contrato',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor)),
                                onPressed: () {
                                  Alerts al = new Alerts();

                                  al.buildDialogTerms(context, document,
                                      buildAlertSendContract);
                                },
                              )
                            ]),
                      ]))));
    });
  }

  buildAlertSendContract(context, DocumentSnapshot doc) {
    final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
    TextEditingController valorTotalController = TextEditingController();
    TextEditingController duracaoController = TextEditingController();

    final CurrencyInputFormatter _formatNumber = new CurrencyInputFormatter();
    Navigator.of(context).pop();

    Alert(
        context: context,
        title: 'Proposta de Serviço',
        style: AlertStyle(
            titleStyle: TextStyle(fontSize: 26), isOverlayTapDismiss: true),
        closeFunction: () {},
        buttons: [
          DialogButton(
            height: 48,
            child: Text("Enviar Proposta",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            color: Theme.of(context).accentColor,
            onPressed: () {
              if (DateTimePicker.selectedDate != null &&
                  DateTimePicker.selectedTime != null) {
                if (fbKey.currentState.validate()) {
                  Navigator.of(context).pop();
                  _saveNewContract(
                      dataInicio: DateTimePicker.selectedDate,
                      horaInicio: DateTimePicker.selectedTime,
                      docProfessional: doc.documentID,
                      docCompany: docCompany,
                      duracao: duracaoController.text,
                      valorTotal: valorTotalController.text,
                      name: doc.data['name'],
                      context: context);
                }
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Você precisa preencher Data e Hora"),
                ));
              }
            },
          )
        ],
        content: FormBuilder(
            key: fbKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              SizedBox(
                height: 30,
              ),
              Text("Valor Total",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              FormBuilderTextField(
                attribute: 'valorField',
                validators: [
                  FormBuilderValidators.required(errorText: 'Campo Obrigatório')
                ],
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                  _formatNumber,
                ],
                controller: valorTotalController,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                initialValue: '',
              ),
              SizedBox(
                height: 20,
              ),
              Text("Duração do Serviço(horas)",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              FormBuilderTextField(
                attribute: 'duracao',
                controller: duracaoController,
                keyboardType: TextInputType.number,
                validators: [
                  FormBuilderValidators.required(errorText: 'Campo Obrigatório')
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text("Data de Início",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              DateTimePicker(false),
              SizedBox(
                height: 20,
              ),
              Text("Hora de Início",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              DateTimePicker(true),
              SizedBox(
                height: 20,
              ),
            ]))).show();
  }

  void _saveNewContract(
      {@required String docProfessional,
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

    HomeCompanyTab.swipeKey.currentState.swipeRight();
  }

  void updateRatingContract(contractId, newRating) async {
    await Firestore.instance
        .collection('contracts')
        .document(contractId)
        .updateData({'ratingCompany': newRating.toString()});
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
