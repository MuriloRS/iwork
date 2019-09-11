import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class AutoCompleteInput extends StatefulWidget {
  List<String> options;
  final String hintText;
  final Stream<Map<String, dynamic>> stream;
  final Function(Map<String, dynamic>) onChanged;
  final GlobalKey<AutoCompleteTextFieldState<String>> _citieController;

  AutoCompleteInput(this.options, this.hintText, this._citieController,
      {this.stream, this.onChanged});

  @override
  _AutoCompleteInputState createState() => _AutoCompleteInputState();
}

class _AutoCompleteInputState extends State<AutoCompleteInput> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String currentText = "";

    return StreamBuilder(
      stream: widget.stream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState.index == ConnectionState.none.index ||
            snapshot.connectionState.index == ConnectionState.waiting.index) {
        } else {
          widget.options = snapshot.data['skills'];
        }

        return _getAutoComplete();
      },
    );
  }

  Widget _getAutoComplete() {
    return SimpleAutoCompleteTextField(
      key: widget._citieController,
      decoration: InputDecoration(
        focusedErrorBorder:
            OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
        errorBorder:
            OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
        helperStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: widget.options == null
            ? Color.fromRGBO(230, 230, 230, 1)
            : Color.fromRGBO(255, 255, 255, 1),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        focusedBorder: OutlineInputBorder(
          borderSide:
              new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide:
                new BorderSide(color: const Color.fromRGBO(210, 210, 210, 1)),
            borderRadius: BorderRadius.all(Radius.circular(3))),
      ),
      controller: controller,
      suggestions: widget.options,
      textChanged: (search) {
        widget.onChanged({'skillSearch': search});
      },
      clearOnSubmit: false,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          controller.text = text;
        }
      }),
    );
  }
}
