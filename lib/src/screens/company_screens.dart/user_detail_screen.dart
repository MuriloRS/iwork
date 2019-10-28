import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/blocs/company_bloc.dart';
import 'package:contratacao_funcionarios/src/shared/alerts.dart';
import 'package:contratacao_funcionarios/src/shared/custom_sliver_appbar.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserDetailScreen extends StatelessWidget {
  final TextStyle styleDefault = TextStyle(fontSize: 16);
  CompanyBloc bloc;
  DocumentSnapshot docProfessional;

  UserDetailScreen(this.docProfessional);

  @override
  Widget build(BuildContext context) {
    bloc = CompanyBloc(docProfessional.documentID);
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
                                    Text("Avaliação média: ",
                                        style: styleDefault),
                                    RatingBar(
                                      initialRating: double.parse(
                                          docProfessional.data['rating']),
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
                                  height: 20,
                                ),
                                Text("Nome: ${docProfessional.data['name']}",
                                    style: styleDefault),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Cidade: ${docProfessional.data['city']}",
                                    style: styleDefault),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    "Funções:" +
                                        ((docProfessional.data['skills']
                                                        as List)
                                                    .length >
                                                0
                                            ? docProfessional.data['skills']
                                                .toString()
                                                .replaceAll('[]', '')
                                                .toString()
                                            : " Sem experiência"),
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
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      onPressed: () {
                                        Alerts al = new Alerts();

                                        al.buildDialogTerms(
                                            context,
                                            this.docProfessional,
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
                      FutureBuilder(
                        future: bloc.searchProfessionalContracts(
                            this.docProfessional.documentID),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState.index ==
                                  ConnectionState.none.index ||
                              snapshot.connectionState.index ==
                                  ConnectionState.waiting.index) {
                            return Loader();
                          } else {
                            if (snapshot.data.documents.length == 0) {
                              return Container(
                                padding: EdgeInsets.all(15),
                                  child: Text(
                                      "${docProfessional.data['name']} não tem nenhum contrato finalizado",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400)));
                            } else {
                              return Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  width: MediaQuery.of(context).size.width - 30,
                                  height:
                                      MediaQuery.of(context).size.height - 420,
                                  child: ListView.separated(
                                    itemCount: snapshot.data.documents.length,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 5,
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                                snapshot.data.documents
                                                    .elementAt(index)
                                                    .data['company'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Theme.of(context)
                                                        .cardColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                    snapshot.data.documents
                                                        .elementAt(index)
                                                        .data['skill'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.grey[400])),
                                                RatingBar(
                                                  initialRating: double.parse(
                                                      snapshot.data.documents
                                                          .elementAt(index)
                                                          .data['rating']),
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  unratedColor:
                                                      Colors.grey[350],
                                                  itemSize: 14,
                                                  itemCount: 5,
                                                  ignoreGestures: true,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 1.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
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
                                  ));
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }
}
