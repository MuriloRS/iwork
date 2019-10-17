import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/user_detail_screen.dart';
import 'package:contratacao_funcionarios/src/screens/login_page.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/home_company_tab.dart';
import 'package:contratacao_funcionarios/src/shared/currency_input_formatter.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

enum StateActual { IDLE, LOADING, SUCCESS, FAIL }

class CompanyBloc extends BlocBase {
  final stateController = BehaviorSubject<StateActual>();
  final searchProfessionalController = BehaviorSubject<Map<String, dynamic>>();
  String docCompany;

  Stream<StateActual> get outState => stateController.stream;
  Stream<Map<String, dynamic>> get outSearchProfessional =>
      searchProfessionalController.stream;

  Sink<Map<String, dynamic>> get doSearchProfessional =>
      searchProfessionalController.sink;

  List<SwiperItem> listProfessionals;

  CompanyBloc(docCompany) {
    searchProfessionalController.stream.listen(searchProfessionals);
    this.docCompany = docCompany;
  }

  void searchProfessionals(params) async {
    stateController.add(StateActual.LOADING);
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
        if (doc.data['rating'] >= params['rating']) {
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

    listProfessionals = list;

    stateController.add(StateActual.SUCCESS);
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
                              initialRating: document.data['rating'],
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemSize: 18,
                              itemCount: 5,
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
                        Text("Funções: ${document.data['skills'].toString()}",
                            style: styleDefault),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: ButtonInput.getButton(TYPE_BUTTON.OUTLINE,
                                COLOR_BUTTON.DEFAULT, 'Ver mais', () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserDetailScreen()));
                            }, context, null, 15)),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.red,
                                child: Text('Rejeitar',
                                    style: TextStyle(fontSize: 18)),
                                onPressed: HomeCompanyTab
                                    .swipeKey.currentState.swipeLeft,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              RaisedButton(
                                  color: Colors.green,
                                  child: Text('Aceitar',
                                      style: TextStyle(fontSize: 18)),
                                  onPressed: () {
                                    _buildAlertSendContract(context, document);
                                  })
                            ]),
                      ]))));
    });
  }

  _buildAlertSendContract(context, DocumentSnapshot doc) {
    final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
    TextEditingController valorTotalController = TextEditingController();
    TextEditingController duracaoController = TextEditingController();
    TextEditingController dataInicioController =
        TextEditingController(text: DateTime.now().toString());
    final CurrencyInputFormatter _formatNumber = new CurrencyInputFormatter();

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
              if (fbKey.currentState.validate()) {
                _saveNewContract(
                    dataInicio: dataInicioController.text,
                    docProfessional: doc.documentID,
                    docCompany: docCompany,
                    duracao: duracaoController.text,
                    valorTotal: valorTotalController.text,
                    context: context);
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
              FlatButton(
                onPressed: () {
                  
                },
                child: Text("''12"),
              ),
              SizedBox(
                height: 20,
              ),
            ]))).show();
  }

  Future<Null> _selectedDate(BuildContext context) async {
    DateTime _date = new DateTime.now();
    TimeOfDay _time = new TimeOfDay.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2019));

    if (picked != null && picked != _date) {
      print("Date selected ${_date.toString()}");
      /*setState(() {
        _date = picked;
      });*/
    }
  }

  void _saveNewContract(
      {@required String docProfessional,
      @required String docCompany,
      @required String valorTotal,
      @required String dataInicio,
      @required String duracao,
      @required BuildContext context}) async {
    await Firestore.instance.collection('contracts').add({
      'totalValue': double.parse(valorTotal),
      'dataInicio': dataInicio,
      'duracao': duracao,
      'professional': docProfessional,
      'company': docCompany,
      'status': 'PENDENTE'
    });

    Navigator.pop(context);

    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      duration: Duration(seconds: 8),
      content: Text(
          "O contrato foi enviado para o Profissional, agora é só aguardar ele aceitar, se prefereir pode ligar para ele para agilizar o processo."),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    searchProfessionalController.close();
    stateController.close();
  }
}
