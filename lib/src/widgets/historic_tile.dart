import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class HistoricTile extends StatelessWidget {
  Map<String, dynamic> contract;
  UserBloc bloc;

  HistoricTile(this.contract, this.bloc);

  @override
  Widget build(BuildContext context) {
    if (contract['status'] == 'PENDENTE' || contract['status'] == 'ANDAMENTO') {
      var formatter = new DateFormat('dd/MM/yyyy');
      var date =
          formatter.format((contract['dataInicio'] as Timestamp).toDate());
      final formatterCurrency =
          new NumberFormat.simpleCurrency(locale: 'pt-br', decimalDigits: 2);

      String newTotalValue = formatterCurrency.format(contract['totalValue']);
      return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: ExpansionTile(
            trailing: Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).primaryColorLight,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(contract['companyName'],
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                Text(contract['status'],
                    style: TextStyle(
                        color: Theme.of(context).hintColor, fontSize: 14))
              ],
            ),
            children: <Widget>[
              Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Data de início: " + date,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Duração(Horas): " + contract['duracao'],
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16)),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Valor: $newTotalValue",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16)),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: bloc.outContractsState,
                        builder: (context, AsyncSnapshot<UserState> snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data) {
                              case UserState.LOADING:
                                return Loader();
                                break;
                              case UserState.SUCCESS:
                                return _getSpecificButton(contract, context);

                                break;
                              default:
                                return _getSpecificButton(contract, context);
                            }
                          } else {
                            return Loader();
                          }
                        },
                      )
                    ],
                  ))
            ],
          ));
    }

    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            title: Text(
              "Rock'n Play",
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).cardColor),
            ),
            subtitle: Text("23/09/2019",
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).cardColor)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Avalie", style: TextStyle(color: Colors.white)),
                RatingBar(
                  initialRating: double.parse(contract['rating'].toString()),
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemSize: 18,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
                  onRatingUpdate: (rating) async {
                    await Firestore.instance
                        .collection('contracts')
                        .document(contract['idDocument'])
                        .updateData({'rating': rating});
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.green,
                      content: Text("Avaliação de $rating foi salva.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ));
                  },
                ),
              ],
            )));
  }

  Widget _getSpecificButton(contract, context) {
    switch (contract['status']) {
      case 'PENDENTE':
        return FlatButton(
          color: Theme.of(context).accentColor,
          child: Text("Aceitar",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16)),
          onPressed: () {
            bloc.statusContractButtonAction(contract);
          },
        );
        break;
      case 'ANDAMENTO':
        return FlatButton(
          color: Theme.of(context).accentColor,
          child: Text("Finalizar",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16)),
          onPressed: () {
            bloc.statusContractButtonAction(contract);
          },
        );
        break;
      case 'FINALIZADO':
        return Row(
          children: <Widget>[
            Text("Avalie a empresa ", style: TextStyle(fontSize: 16)),
            RatingBar(
              initialRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 16,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            )
          ],
        );
        break;

      default:
        return Container();
    }
  }
}
