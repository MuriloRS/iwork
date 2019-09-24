import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:flutter/material.dart';

class ComboboxButton extends StatefulWidget {
  final List<DropdownMenuItem> options;
  final String hintText;
  final UserProviderModel model;

  ComboboxButton(
      {@required this.options, @required this.hintText, @required this.model});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<ComboboxButton> {
  String selected;
  @override
  Widget build(BuildContext context) {
    
    return DropdownButtonHideUnderline(
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: ShapeDecoration(
              color: widget.options == null
                  ? Color.fromRGBO(220, 220, 220, 0.5)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: const Color.fromRGBO(210, 210, 210, 1)),
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
            ),
            child: DropdownButton(
              hint: Text(
                widget.hintText,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
                textAlign: TextAlign.center,
              ),
              items: widget.options,
              value: selected,
              onChanged: (newValue) {
                setState(() {
                  selected = newValue;
                });

                widget.model.userData['acceptAnyTime'] =
                    newValue == 'Sim' ? true : false;
              },
              isExpanded: true,
              elevation: 5,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            )));
  }
}
