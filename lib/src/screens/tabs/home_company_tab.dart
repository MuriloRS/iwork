import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
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
        child: CustomScrollView(slivers: <Widget>[
      CustomSliverAppbar(""),
      SliverToBoxAdapter(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height - 80,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Profissionais Encontrados: 5",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: MediaQuery.of(context).size.height - 300,
                      width: MediaQuery.of(context).size.width - 40,
                      child: Card(
                        elevation: 4,
                        child: Container(
                          padding: EdgeInsets.all(25),
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
                              Text("Nome: ${_model.userData['name']}",
                                  style: styleDefault),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Idade: ", style: styleDefault),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Cidade: ", style: styleDefault),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Funções: ", style: styleDefault),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: ButtonInput.getButton(
                                      TYPE_BUTTON.OUTLINE,
                                      COLOR_BUTTON.DEFAULT,
                                      'Ver mais',
                                      () {},
                                      context,
                                      null))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                child: Icon(
                  FontAwesomeIcons.stream,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {},
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      )
    ]));
  }
}
