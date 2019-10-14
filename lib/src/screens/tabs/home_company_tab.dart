import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/user_detail_screen.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_company_tab.dart';
import 'package:contratacao_funcionarios/src/shared/custom_sliver_appbar.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class HomeCompanyTab extends StatelessWidget {
  final TextStyle styleDefault = TextStyle(fontSize: 18);
  UserProviderModel _model;

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<UserProviderModel>(context);

    if (!_model.userData['profileCompleted']) {
      return AccountCompanyTab();
    }

    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        child: Container(
          color: Colors.grey[700],
          height: 1.0,
          child: Text(),
        ),
        preferredSize: Size.fromHeight(1.0)),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          FontAwesomeIcons.stream,
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {},
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
            height: MediaQuery.of(context).size.height - 80,
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "5 Profissionais Encontrados",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).cardColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: MediaQuery.of(context).size.height - 280,
                    width: MediaQuery.of(context).size.width - 40,
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
                                Text("Avaliação: ", style: styleDefault),
                                RatingBar(
                                  initialRating: 4.5,
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
                            Text("Nome: Murilo ", style: styleDefault),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Idade: 22", style: styleDefault),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Cidade: Santa Cruz do Sul",
                                style: styleDefault),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Funções: Garçom, pedreiro",
                                style: styleDefault),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: ButtonInput.getButton(
                                    TYPE_BUTTON.OUTLINE,
                                    COLOR_BUTTON.DEFAULT,
                                    'Ver mais', () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          UserDetailScreen()));
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
                                  onPressed: () {},
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                RaisedButton(
                                  color: Colors.green,
                                  child: Text('Aceitar',
                                      style: TextStyle(fontSize: 18)),
                                  onPressed: () {},
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              child: Icon(
                FontAwesomeIcons.stream,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
              backgroundColor: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
    ));
  }
}
