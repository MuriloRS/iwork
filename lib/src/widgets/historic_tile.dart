import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HistoricTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(5),
      title: Text(
        "Empresa",
        style: TextStyle(fontSize: 18),
      ),
      subtitle: Text("23/09/2019"),
      trailing: RatingBar(
        initialRating: 4.5,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemSize: 15,
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
    );
  }
}
