import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/blocs/company_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/shared/default_sliver_scaffold.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CompanyContractsTab extends StatelessWidget {
  UserProviderModel _model;
  CompanyBloc bloc;

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<UserProviderModel>(context);
    bloc = new CompanyBloc(_model.userFirebase.uid);

    return DefaultSliverScaffold(
        titleScaffold: "Contratos",
        content: Container(
            padding: EdgeInsets.all(15),
            child: FutureBuilder(
              future: bloc.searchCompanyContracts(_model.userFirebase.uid),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState.index ==
                        ConnectionState.none.index ||
                    snapshot.connectionState.index ==
                        ConnectionState.waiting.index) {
                  return Center(child:Loader());
                } else {
                  List<Widget> listContracts = new List();

                  snapshot.data.documents.forEach((doc) {
                    var formatter = new DateFormat('dd/MM/yyyy');
                    var date = formatter
                        .format((doc.data['dataInicio'] as Timestamp).toDate());

                    listContracts.add(Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Theme.of(context).primaryColorLight,
                      ),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Text(
                            date.toString().split(' ').elementAt(0),
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Nome: ' + doc.data['nameProfessional'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.grey[200], fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Status: ' + doc.data['status'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.grey[200], fontSize: 18),
                              ),
                            ],
                          ),
                          doc.data['status'] == 'FINALIZADO'
                              ? Column(children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Avalie',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.grey[200],
                                            fontSize: 22),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      RatingBar(
                                        initialRating:
                                            double.parse(doc.data['rating']),
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        unratedColor: Colors.grey[200],
                                        itemSize: 22,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 22,
                                        ),
                                        onRatingUpdate: (rating) {
                                          bloc.updateRatingContract(
                                              doc.documentID, rating);
                                        },
                                      ),
                                    ],
                                  )
                                ])
                              : Container(),
                        ],
                      ),
                    ));
                  });

                  return Container(
                    height: MediaQuery.of(context).size.height - 120,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemCount: listContracts.length,
                      itemBuilder: (context, index) {
                        return listContracts.elementAt(index);
                      },
                    ),
                  );
                }
              },
            )));
  }
}
