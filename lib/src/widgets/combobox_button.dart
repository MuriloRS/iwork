import 'package:flutter/material.dart';

class ComboboxButton extends StatefulWidget {
  final List<DropdownMenuItem> options;
  final String hintText;

  ComboboxButton({@required this.options, @required this.hintText});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<ComboboxButton> {
  String _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: Container(
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
              ),
              items: widget.options,
              value: _selectedLocation,
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
              isExpanded: true,
              elevation: 5,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            )));
  }
}
