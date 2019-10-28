import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
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
    UserModel _model = Provider.of<UserModel>(context);
    bloc = new UserBloc();

    if (!_model.profileCompleted) {
      return AccountUserTab();
    }

    return SafeArea(
        child: CustomScrollView(slivers: <Widget>[
      CustomSliverAppbar("Início"),
      SliverToBoxAdapter(
          child: FutureBuilder(
        future: bloc.getUserContracts(_model.documentId),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState.index == ConnectionState.none.index ||
              snapshot.connectionState.index == ConnectionState.waiting.index) {
            return Container(
                padding: EdgeInsets.all(15), child: Center(child: Loader()));
          } else {
            List<Map<String, dynamic>> listContracts = new List();
            int numberContractsFinished = 0;

            snapshot.data.forEach((c) {
              if (c['status'] == 'FINALIZADO') {
                numberContractsFinished++;
              }

              listContracts.add(c);
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
                              _model.name,
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
                                  ignoreGestures: true,
                                  initialRating: double.parse(_model.rating),
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  unratedColor: Colors.grey[350],
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
                  StreamBuilder(
                    stream: bloc.outContractsState,
                    builder: (context, AsyncSnapshot<UserState> snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data) {
                          case UserState.LOADING:
                            return Loader();
                            break;
                          case UserState.SUCCESS:
                            listContracts = _listContractsUpdted(
                                bloc.newContract, listContracts);

                            return _getListView(listContracts, context);

                            break;
                          default:
                            return _getListView(listContracts, context);
                        }
                      } else {
                        return Loader();
                      }
                    },
                  )
                ],
              ),
            );
          }
        },
      ))
    ]));
  }

  List<Map<String, dynamic>> _listContractsUpdted(
      newContract, List<Map<String, dynamic>> listContracts) {
    List<Map<String, dynamic>> listUpdated = new List();

    listContracts.forEach((map) {
      if (map['idDocument'] == newContract['idDocument']) {
        listUpdated.add(newContract);
      } else {
        listUpdated.add(map);
      }
    });

    return listUpdated;
  }

  Widget _getListView(listContracts, context) {
    List<Widget> listContractsListview = new List();

    listContracts.forEach((c) {
      listContractsListview.add(HistoricTile(c, bloc));
    });

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        height: MediaQuery.of(context).size.height - 260,
        child: ListView.separated(
          itemCount: listContractsListview.length,
          separatorBuilder: (context, i) {
            return SizedBox(
              height: 5,
            );
          },
          itemBuilder: (context, i) {
            return listContractsListview.elementAt(i);
          },
        ));
  }
}
