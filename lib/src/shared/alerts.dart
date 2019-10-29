import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  void buildDialogTerms(BuildContext context, DocumentSnapshot doc, String
      nameCompany, Function(BuildContext, DocumentSnapshot, String) contractDialog) {
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
}
