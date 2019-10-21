import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/blocs/company_bloc.dart';
import 'package:contratacao_funcionarios/src/shared/alerts.dart';
import 'package:contratacao_funcionarios/src/shared/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserDetailScreen extends StatelessWidget {
  final TextStyle styleDefault = TextStyle(fontSize: 16);
  CompanyBloc bloc;
  DocumentSnapshot docCompany;

  UserDetailScreen(this.docCompany);

  @override
  Widget build(BuildContext context) {
    bloc = CompanyBloc(docCompany.documentID);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: CustomScrollView(slivers: <Widget>[
              CustomSliverAppbar("Murilo Haas"),
              SliverToBoxAdapter(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 15, left: 0, right: 0),
                        height: MediaQuery.of(context).size.height - 400,
                        width: MediaQuery.of(context).size.width - 30,
                        child: Card(
                          elevation: 4,
                          child: Container(
                            padding: EdgeInsets.only(
                                right: 20, left: 20, top: 20, bottom: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Avaliação média: ", style: styleDefault),
                                    RatingBar(
                                      initialRating: docCompany.data['rating'],
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
                                  height: 20,
                                ),
                                Text("Nome: ${docCompany.data['name']}", style: styleDefault),
                                SizedBox(
                                  height: 20,
                                ),
                                
                                Text("Cidade: ${docCompany.data['city']}",
                                    style: styleDefault),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Funções: ${docCompany.data['skills']}",
                                    style: styleDefault),
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
                                          style: TextStyle(fontSize: 15, color: Theme.of(context).primaryColor)),
                                      onPressed: () {
                                        Alerts al = new Alerts();

                                        al.buildDialogTerms(
                                            context,
                                            this.docCompany,
                                            bloc.buildAlertSendContract);
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Experiências",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).accentColor)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          width: MediaQuery.of(context).size.width - 30,
                          height: MediaQuery.of(context).size.height - 420,
                          child: ListView.separated(
                            itemCount: 10,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 5,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: <Widget>[
                                    Text("Rock'n Play",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Theme.of(context).cardColor,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Garçom",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[400])),
                                        RatingBar(
                                          initialRating: 3.5,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemSize: 14,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ))
                    ],
                  ),
                ),
              )
            ])));
  }
}
