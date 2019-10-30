import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/blocs/company_bloc.dart';
import 'package:contratacao_funcionarios/src/shared/currency_input_formatter.dart';
import 'package:contratacao_funcionarios/src/widgets/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Alerts {
  static void buildCupertinoDialog(
      {@required String title,
      List<Widget> actions,
      @required BuildContext context,
      @required Widget content}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            content: content,
            actions: actions,
          );
        });
  }

  void buildDialogTerms(
      BuildContext context,
      DocumentSnapshot doc,
      String nameCompany,
      Function(BuildContext, DocumentSnapshot, String) contractDialog) {
    Alert(
        context: context,
        title: 'Termos de Serviço',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
                "Esses são os termos de serviço da nossa plataforma, você precisa concordar com eles para enviar um contrato para um profissional",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(
              height: 16,
            ),
            Text(
                " - O contrato e forma de pagamento devem ser acordados entre a empresa e o profissional.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800])),
            SizedBox(
              height: 10,
            ),
            Text(
                " - Nós não nos responsabilizamos por quebra de contrato, não pagamento.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800])),
            SizedBox(
              height: 10,
            ),
            Text(
                " - Caso ocorra algum problema nossa equipe deve ser informada para tomar as medidas cabíveis.",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800])),
            SizedBox(
              height: 10,
            )
          ],
        ),
        buttons: [
          DialogButton(
            child: Text("Aceito",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            onPressed: () {
              contractDialog(context, doc, nameCompany);
            },
          )
        ]).show();
  }

  static void dialogFilter(
      context, CompanyBloc bloc, DocumentSnapshot doc, docCompany) {
    final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
    TextEditingController valorTotalController = TextEditingController();
    TextEditingController posicaoController = TextEditingController();
    TextEditingController duracaoController = TextEditingController();

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
              if (DateTimePicker.selectedDate != null &&
                  DateTimePicker.selectedTime != null) {
                bloc.stateController.add(StateCurrent.IDLE);

                if (fbKey.currentState.validate()) {
                  Navigator.of(context).pop();

                  bloc.saveNewContract(
                      role: posicaoController.text,
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
                bloc.stateController.add(StateCurrent.FAIL);
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
                height: 15,
              ),
              StreamBuilder(
                  stream: bloc.stateController,
                  builder: (context, AsyncSnapshot<StateCurrent> snapshot) {
                    switch (snapshot.data) {
                      case StateCurrent.FAIL:
                        return Card(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Text(
                                    "Todos os campos são obrigatórios para enviar a proposta.",
                                    style: TextStyle(color: Colors.white),
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                              )),
                          color: Colors.red,
                        );
                        break;
                      default:
                        return Container();
                    }
                  }),
              SizedBox(
                height: 15,
              ),
              Text("Valor Total*",
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
              Text("Duração do Serviço(horas)*",
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
              Text("Posição*",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              FormBuilderTextField(
                attribute: 'posicaoField',
                validators: [
                  FormBuilderValidators.required(errorText: 'Campo Obrigatório')
                ],
                controller: posicaoController,
                initialValue: '',
              ),
              SizedBox(
                height: 15,
              ),
              Text("Data de Início*",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              DateTimePicker(false),
              SizedBox(
                height: 20,
              ),
              Text("Hora de Início*",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              DateTimePicker(true),
              SizedBox(
                height: 20,
              ),
            ]))).show();
  }
}
