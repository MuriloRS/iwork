import 'package:flutter/material.dart';

enum TYPE_BUTTON { NORMAL, IMAGE, OUTLINE }
enum COLOR_BUTTON { PRIMARY, ACCENT, HINT, DEFAULT }

class ButtonInput {
  ButtonInput._();

  static Widget getButton(TYPE_BUTTON type, COLOR_BUTTON color, String text,
      Function() buttonFunction, BuildContext context, Icon icon) {
    switch (type) {
      case TYPE_BUTTON.NORMAL:
        return FlatButton(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(
            text,
            style: color == COLOR_BUTTON.DEFAULT
                ? TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w600)
                : TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          color: _getColorButton(color, context),
          textColor: Colors.white,
          onPressed: () {
            buttonFunction();
          },
        );
        break;
      case TYPE_BUTTON.IMAGE:
        return FlatButton(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: color == COLOR_BUTTON.DEFAULT
                    ? TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                        fontWeight: FontWeight.w600)
                    : TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )
            ],
          ),
          color: _getColorButton(color, context),
          textColor: Colors.white,
          onPressed: () {
            buttonFunction();
          },
        );
        break;
      case TYPE_BUTTON.OUTLINE:
        return FlatButton(

            color: _getColorButton(color, context),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              text,
              style: color == COLOR_BUTTON.DEFAULT
                  ? TextStyle(
                      color: Colors.grey[800],
                      fontSize: 20,
                      fontWeight: FontWeight.w600)
                  : TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              buttonFunction();
            },
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)));
        break;
      default:
    }
  }

  static Color _getColorButton(color, context) {
    switch (color) {
      case COLOR_BUTTON.PRIMARY:
        return Theme.of(context).primaryColor;
        break;
      case COLOR_BUTTON.ACCENT:
        return Theme.of(context).accentColor;
        break;
      case COLOR_BUTTON.HINT:
        return Theme.of(context).hintColor;
        break;
      case COLOR_BUTTON.DEFAULT:
        return Colors.grey[300];
        break;
    }
  }
}
