import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:contratacao_funcionarios/src/blocs/account_user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/shared/default_sliver_scaffold.dart';
import 'package:contratacao_funcionarios/src/widgets/autocomplete_input.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AccountCompanyTab extends StatefulWidget {
  @override
  _AccountCompanyTabState createState() => _AccountCompanyTabState();
}

class _AccountCompanyTabState extends State<AccountCompanyTab> {
  TextEditingController _nomeInputController;
  TextEditingController _emailInputController;
  TextEditingController _telefoneInputController;
  GlobalKey<AutoCompleteTextFieldState<String>> _citieController =
      new GlobalKey();
  UserProviderModel _model;
  AccountUserBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _nomeInputController = TextEditingController();
    _emailInputController = TextEditingController();
    _telefoneInputController = TextEditingController();
    _model = Provider.of<UserProviderModel>(context);
    _bloc = AccountUserBloc();

    _nomeInputController.text = _model.userData['name'];
    _emailInputController.text = _model.userFirebase.email;
    _telefoneInputController.text = _model.userData['telephone'];

    _listenOutState();

    return DefaultSliverScaffold(
        titleScaffold: "Conta",
        content: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(children: <Widget>[
              SingleChildScrollView(
                  child: Container(
                      child: Column(children: <Widget>[
                InputField(
                    _nomeInputController,
                    false,
                    TextInputType.text,
                    'Nome Completo*',
                    [
                      FormBuilderValidators.required(
                          errorText: "O campo nome é obrigatório")
                    ],
                    _bloc.outName,
                    _bloc.changeName,
                    'Nome conta',
                    false),
                SizedBox(
                  height: 20,
                ),
                InputField(
                    _emailInputController,
                    false,
                    TextInputType.text,
                    'Email',
                    [
                      FormBuilderValidators.required(
                          errorText: "O campo email é obrigatório")
                    ],
                    _bloc.outName,
                    _bloc.changeName,
                    'Email conta',
                    false),
                SizedBox(
                  height: 20,
                ),
                InputField(
                    _telefoneInputController,
                    false,
                    TextInputType.number,
                    'Telefone',
                    [],
                    _bloc.outTelephone,
                    _bloc.changeTelephone,
                    'telefone conta',
                    false),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: _bloc.getCities(context),
                  builder: (context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState.index ==
                            ConnectionState.none.index ||
                        snapshot.connectionState.index ==
                            ConnectionState.waiting.index) {
                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          AutoCompleteInput(
                              null, 'Cidade*', null, _model, null, null, ''),
                          Center(
                            child: Container(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  backgroundColor: Colors.white,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.green[600]),
                                )),
                          )
                        ],
                      );
                    } else {
                      return AutoCompleteInput(
                          snapshot.data,
                          'Cidade*',
                          _citieController,
                          _model,
                          _bloc.outCities,
                          _bloc.changeCities,
                          _model.userData['city']);
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                StreamBuilder(
                  stream: _bloc.outState,
                  builder:
                      (context, AsyncSnapshot<AccountUserState> stateSnapshot) {
                    switch (stateSnapshot.data) {   
                      case AccountUserState.LOADING:
                        return Loader();
                        break;
                      default:
                        return Container(
                          width: double.infinity,
                          child: ButtonInput.getButton(
                              TYPE_BUTTON.IMAGE, COLOR_BUTTON.HINT, 'Salvar',
                              () {
                            _model.userData['name'] = _nomeInputController.text;
                            _model.userData['telephone'] =
                                _telefoneInputController.text;

                            _bloc.saveController.add(_model);
                          }, context, Icon(FontAwesomeIcons.save)),
                        );
                    }
                  },
                )
              ])))
            ])));
  }

  void _listenOutState() {
    _bloc.outState.listen((state) {
      switch (state) {
        case AccountUserState.SUCCESS:
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 10),
            elevation: 5,
            content: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text("Seu cadastro foi salvo!",
                    style: TextStyle(fontSize: 18))),
          ));
          break;
        case AccountUserState.FAIL:
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 10),
            elevation: 5,
            content: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text("Algum campo não foi preenchido!",
                    style: TextStyle(fontSize: 18))),
          ));
          break;
        default:
          return Container();
      }
    });
  }
}
