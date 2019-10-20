import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  void buildDialogTerms(BuildContext context, DocumentSnapshot doc,
      Function(BuildContext, DocumentSnapshot) contractDialog) {
    buildCupertinoDialog(
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
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              " - O contrato e forma de pagamento devem ser acordados entre a empresa e o profissional.",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              " - Nós não nos responsabilizamos por quebra de contrato, não pagamento.",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              " - Caso ocorra algum problema nossa equipe deve ser informada para tomar as medidas cabíveis.",
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("Aceito"),
            isDefaultAction: true,
            onPressed: () {
              contractDialog(context, doc);

            },
          )
        ]);
  }
}
