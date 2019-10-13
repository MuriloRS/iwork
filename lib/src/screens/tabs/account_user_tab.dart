import 'package:contratacao_funcionarios/src/blocs/account_user_bloc.dart';
import 'package:contratacao_funcionarios/src/blocs/user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/shared/default_sliver_scaffold.dart';
import 'package:contratacao_funcionarios/src/widgets/autocomplete_input.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:contratacao_funcionarios/src/widgets/combobox_button.dart';
import 'package:contratacao_funcionarios/src/widgets/download_input_button.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AccountUserTab extends StatefulWidget {
  @override
  _AccountUserTabState createState() => _AccountUserTabState();
}

class _AccountUserTabState extends State<AccountUserTab> {
  TextEditingController _nomeInputController;
  TextEditingController _skillsInputController;
  TextEditingController _emailInputController;
  TextEditingController _telephoneController;
  GlobalKey<AutoCompleteTextFieldState<String>> _citieController =
      new GlobalKey();
  AccountUserBloc _bloc;
  UserProviderModel _model;

  UserBloc _userBloc;

  @override
  Widget build(BuildContext context) {
    _nomeInputController = TextEditingController();
    _emailInputController = TextEditingController();
    _skillsInputController = TextEditingController();
    _telephoneController = TextEditingController();

    _model = Provider.of<UserProviderModel>(context);

    _bloc = AccountUserBloc();
    _userBloc = UserBloc(_model);

    String _selectedLocation;

    _emailInputController.text = _model.userFirebase.email;
    _nomeInputController.text = _model.userData['name'];
    _skillsInputController.text = _userBloc.getUserSkills().trim();
    _telephoneController.text = _model.userData['telephone'];

    _listenOutState();

    return DefaultSliverScaffold(
        titleScaffold: "Conta",
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                    child: Column(
                  children: <Widget>[
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
                        TextInputType.emailAddress,
                        'Email*',
                        [
                          FormBuilderValidators.required(
                              errorText: "O campo email é obrigatório")
                        ],
                        null,
                        null,
                        'Email conta',
                        false),
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                        _telephoneController,
                        false,
                        TextInputType.number,
                        'Telefone*',
                        [
                          FormBuilderValidators.required(
                              errorText: "O campo telefone é obrigatório")
                        ],
                        _bloc.outTelephone,
                        _bloc.changeTelephone,
                        'Telefone conta',
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
                              AutoCompleteInput(null, 'Cidade*', null, _model,
                                  null, null, ''),
                              Center(
                                child: Container(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
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
                      height: 20,
                    ),
                    InputField(
                        _skillsInputController,
                        false,
                        TextInputType.multiline,
                        'Habilidades',
                        [],
                        _bloc.outSkills,
                        _bloc.changeSkills,
                        'Habilidades input',
                        false),
                    Text(
                      "Coloque apenas o que você já tem experiência. Separe por virgula, ex: mecânico, garçom.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Aceitar trabalho em qualquer horário? ",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Theme.of(context).cardColor, fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ComboboxButton(options: [
                      DropdownMenuItem(
                        child: Text('Sim',
                            style: TextStyle(color: Colors.grey[700])),
                        value: 'Sim',
                      ),
                      DropdownMenuItem(
                        child: Text('Não',
                            style: TextStyle(color: Colors.grey[700])),
                        value: 'Não',
                      )
                    ], model: this._model, hintText: ""),
                    Text(
                      "Os estabelecimentos poderão entrar em contato em fins de semana, tarde da noite ou de madruga para resolver alguma emergência?",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DownloadInputButton(_bloc, _model),
                  ],
                )),
              ),
              SizedBox(
                height: 25,
              ),
              StreamBuilder(
                stream: _bloc.stateController,
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
                            TYPE_BUTTON.IMAGE, COLOR_BUTTON.ACCENT, 'Salvar', () {
                          _model.userData['name'] = _nomeInputController.text;
                          _model.userData['telephone'] =
                              _telephoneController.text;

                          _model.userData['skills'] = _skillsInputController
                              .text
                              .replaceAll(' ', '')
                              .split(",");

                          _bloc.saveController.add(_model);
                        }, context, Icon(FontAwesomeIcons.save, color: Theme.of(context).primaryColor)),
                      );
                  }
                },
              )
            ],
          ),
        ));
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
