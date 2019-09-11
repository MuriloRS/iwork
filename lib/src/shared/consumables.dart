import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Consumables {
  Future<List<DropdownMenuItem>> getBrazilianStates() async {
    List<DropdownMenuItem> states = new List();

    try {
      Response response = await Dio()
          .get("https://servicodados.ibge.gov.br/api/v1/localidades/estados");

      response.data.forEach((m) {
        states.add(DropdownMenuItem(
          child: Text(m['nome']),
        ));
      });
    } catch (e) {
      print(e);
    }

    return states;
  }
}
