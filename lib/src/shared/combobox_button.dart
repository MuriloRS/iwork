import 'package:flutter/material.dart';

class ComboboxButton extends StatefulWidget {
  final List<DropdownMenuItem> options;
  final String hintText;

  ComboboxButton({@required this.options, @required this.hintText});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<ComboboxButton> {
  String _selectedLocation ;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: ShapeDecoration(
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
              ),
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
              items: widget.options,
              isExpanded: true,
              elevation: 5,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            )));
  }
}
