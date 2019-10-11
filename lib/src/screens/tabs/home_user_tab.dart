import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_user_tab.dart';
import 'package:contratacao_funcionarios/src/shared/custom_sliver_appbar.dart';
import 'package:contratacao_funcionarios/src/widgets/historic_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class HomeUserTab extends StatelessWidget {
  final PageController pageController;

  HomeUserTab(this.pageController);

  @override
  Widget build(BuildContext context) {
    UserProviderModel _model = Provider.of<UserProviderModel>(context);

    if (!_model.userData['profileCompleted']) {
      return AccountUserTab();
    }

    return SafeArea(
        child: CustomScrollView(slivers: <Widget>[
      CustomSliverAppbar("Início"),
      SliverToBoxAdapter(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: <Widget>[
              Text(
                "Perfil",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).cardColor),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                color: Colors.grey[100],
                elevation: 3,
                child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Text(
                          "Murilo hass",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Trabalhos realizados: 5",
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
                  height: MediaQuery.of(context).size.height - 310,
                  child: ListView.separated(
                    itemCount: 6,
                    separatorBuilder: (context, i) {
                      return SizedBox(
                        height: 5,
                      );
                    },
                    itemBuilder: (context, i) {
                      return HistoricTile();
                    },
                  ))
            ],
          ),
        ),
      )
    ]));
  }
}
