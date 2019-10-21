import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_user_tab.dart';
import 'package:contratacao_funcionarios/src/shared/custom_sliver_appbar.dart';
import 'package:contratacao_funcionarios/src/widgets/historic_tile.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class HomeUserTab extends StatelessWidget {
  final PageController pageController;
  UserBloc bloc;

  HomeUserTab(this.pageController);

  @override
  Widget build(BuildContext context) {
    UserProviderModel _model = Provider.of<UserProviderModel>(context);
    bloc = new UserBloc();

    if (!_model.userData['profileCompleted']) {
      return AccountUserTab();
    }

    return SafeArea(
        child: CustomScrollView(slivers: <Widget>[
      CustomSliverAppbar("Início"),
      SliverToBoxAdapter(
          child: FutureBuilder(
        future: bloc.getUserContracts(_model.userFirebase.uid),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState.index == ConnectionState.none.index ||
              snapshot.connectionState.index == ConnectionState.waiting.index) {
            return Container(
                padding: EdgeInsets.all(15), child: Center(child: Loader()));
          } else {
            List<Widget> listContracts = new List();
            int numberContractsFinished = 0;

            if (snapshot.data == null) {
              return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          "Nenhum Contrato Recebido, para aumentar suas chances vá em sua conta e ative a opção 'Aceitar trabalhos sem experiência'.",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ));
            }

            snapshot.data.forEach((c) {
              if (c['status'] == 'FINISHED') {
                numberContractsFinished++;
              }
              listContracts.add(HistoricTile(c));
            });

            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.grey[100],
                    elevation: 3,
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          textDirection: TextDirection.ltr,
                          children: <Widget>[
                            Text(
                              _model.userData['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Trabalhos finalizados: $numberContractsFinished",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Avaliação média: ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                RatingBar(
                                  initialRating: _model.userData['rating'],
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemSize: 18,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 1.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: MediaQuery.of(context).size.height - 260,
                      child: ListView.separated(
                        itemCount: listContracts.length,
                        separatorBuilder: (context, i) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                        itemBuilder: (context, i) {
                          return listContracts.elementAt(i);
                        },
                      ))
                ],
              ),
            );
          }
        },
      ))
    ]));
  }
}
