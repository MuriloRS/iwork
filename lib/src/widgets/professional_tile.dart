import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfessionalTile extends StatelessWidget {
  String nameCompany;
  DocumentSnapshot documentProfessional;

  ProfessionalTile(this.documentProfessional, this.nameCompany);

  TextStyle styleDefault = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: new BorderRadius.all(
              const Radius.circular(5.0),
            )),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Avaliação: ", style: styleDefault),
                      RatingBar(
                        initialRating:
                            double.parse(documentProfessional.data['rating']),
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        ignoreGestures: true,
                        itemSize: 18,
                        itemCount: 5,
                        unratedColor: Colors.grey[350],
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
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
                    height: 10,
                  ),
                  Text("Nome: ${documentProfessional.data['name']} ",
                      style: styleDefault),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Funções:" +
                          ((documentProfessional.data['skills'] as List)
                                      .length >
                                  0
                              ? documentProfessional.data['skills']
                                  .toString()
                                  .replaceAll('[]', '')
                                  .toString()
                              : " Sem experiência"),
                      style: styleDefault),
                ]),
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UserDetailScreen(documentProfessional, nameCompany)));
              },
              color: Theme.of(context).hintColor,
              child: Text("Detalhes",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).primaryColorLight)),
            )
          ],
        ));
  }
}
