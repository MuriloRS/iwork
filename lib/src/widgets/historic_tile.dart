import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HistoricTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          title: Text(
            "Rock'n Play",
            style: TextStyle(fontSize: 20, color: Theme.of(context).cardColor),
          ),
          subtitle: Text("23/09/2019",
              style:
                  TextStyle(fontSize: 16, color: Theme.of(context).cardColor)),
          trailing: RatingBar(
            initialRating: 4.5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemSize: 14,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
              size: 14,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
        ));
  }
}
