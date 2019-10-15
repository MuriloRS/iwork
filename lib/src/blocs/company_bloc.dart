import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/user_detail_screen.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:swipe_stack/swipe_stack.dart';

enum State { IDLE, LOADING, SUCCESS, FAIL }

class CompanyBloc extends BlocBase {
  final stateController = BehaviorSubject<State>();
  Stream<State> get outState => stateController.stream;

  Future<Map<String, dynamic>> getProfessionals() {
    //Firestore.instance.
  }

  Future<List<SwiperItem>> searchProfessionals(context) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('users')
        .where('isCompany', isEqualTo: false)
        .where('profileCompleted', isEqualTo: true)
        .getDocuments();

    List<SwiperItem> list = new List();
    snapshot.documents.asMap().forEach((index, doc) {
      list.add(_buildSwiperItem(context, doc));
    });

    return list;
  }

  SwiperItem _buildSwiperItem(context, DocumentSnapshot document) {
    final TextStyle styleDefault = TextStyle(fontSize: 18);

    return SwiperItem(builder: (SwiperPosition pos, double progress) {
      Material(
          child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          Container(
            height: MediaQuery.of(context).size.height - 280,
            width: MediaQuery.of(context).size.width - 40,
            child: Card(
              elevation: 4,
              child: Container(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Avaliação: ", style: styleDefault),
                        RatingBar(
                          initialRating: document.data['rating'],
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemSize: 18,
                          itemCount: 5,
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
                      height: 20,
                    ),
                    Text("Nome: ${document.data['name']} ",
                        style: styleDefault),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Cidade: ${document.data['city']}",
                        style: styleDefault),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Funções: ${document.data['skills'].toString()}",
                        style: styleDefault),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: ButtonInput.getButton(TYPE_BUTTON.OUTLINE,
                            COLOR_BUTTON.DEFAULT, 'Ver mais', () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserDetailScreen()));
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
                          child:
                              Text('Rejeitar', style: TextStyle(fontSize: 18)),
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child:
                              Text('Aceitar', style: TextStyle(fontSize: 18)),
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
      ));
    });
  }

  @override
  void dispose() {
    super.dispose();

    stateController.close();
  }
}
