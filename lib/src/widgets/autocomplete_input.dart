import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:flutter/material.dart';

class AutoCompleteInput extends StatefulWidget {
  final List<String> options;
  final String hintText;
  final GlobalKey<AutoCompleteTextFieldState<String>> _citieController;
  final UserModel _model;
  final Stream<String> stream;
  final Function(String) onChanged;
  final String city;

  AutoCompleteInput(this.options, this.hintText, this._citieController,
      this._model, this.stream, this.onChanged, this.city);

  @override
  _AutoCompleteInputState createState() => _AutoCompleteInputState();
}

class _AutoCompleteInputState extends State<AutoCompleteInput> {
  TextEditingController controller;
  String currentText;

  @override
  Widget build(BuildContext context) {
    controller = TextEditingController();
    controller.text = widget.city;
    currentText = widget.city;


    return StreamBuilder<String>(
      stream: widget.stream,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return SimpleAutoCompleteTextField(
          key: widget._citieController,
          controller: controller,
          suggestions: widget.options,
          clearOnSubmit: false,
          textChanged: (s){
            widget._model.city = s;
          },
          textSubmitted: (text) => setState(() {
            if (text != "") {
              controller.text = text;
            }

            widget._model.city = text;
          }),
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.red)),
            errorBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.red)),
            helperStyle: TextStyle(color: Colors.black),
            errorText: !snapshot.hasError ? snapshot.error : null,
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
                borderSide: new BorderSide(
                    color: const Color.fromRGBO(210, 210, 210, 1)),
                borderRadius: BorderRadius.all(Radius.circular(3))),
          ),
        );
      },
    );
  }
}
