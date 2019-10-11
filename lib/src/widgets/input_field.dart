import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String hintText;
  final bool isPassword;
  final List<String Function(dynamic)> validators;
  final Stream<String> stream;
  final Function(String) onChanged;
  final String atribute;
  final bool isLoginInput;

  InputField(
      this.controller,
      this.isPassword,
      this.type,
      this.hintText,
      this.validators,
      this.stream,
      this.onChanged,
      this.atribute,
      this.isLoginInput);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return FormBuilderTextField(
            maxLines: type == TextInputType.multiline ? 5 : 1,
            onChanged: onChanged,
            attribute: atribute,
            keyboardType: type,
            obscureText: isPassword,
            controller: this.controller,
            decoration: _getInputDecoration(isLoginInput, snapshot, hintText),
            validators: validators,
          );
        });
  }
}

InputDecoration _getInputDecoration(
    bool isLoginInput, AsyncSnapshot snapshot, String hintText) {
  return isLoginInput
      ? InputDecoration(
          focusedErrorBorder:
              OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          errorBorder:
              OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          errorText: snapshot.hasError ? snapshot.error : null,
          filled: true,
          fillColor: const Color.fromRGBO(240, 240, 240, 1),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          focusedBorder: OutlineInputBorder(
            borderSide:
                new BorderSide(color: const Color.fromRGBO(230, 230, 230, 1)),
            
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
        )
      : InputDecoration(
          focusedErrorBorder:
              OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          errorBorder:
              OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          errorText: snapshot.hasError ? snapshot.error : null,
          helperStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: Color.fromRGBO(255, 255, 255, 1),
          hintText: hintText,
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
        );
}
