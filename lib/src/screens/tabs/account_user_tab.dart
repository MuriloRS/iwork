import 'package:contratacao_funcionarios/src/blocs/account_user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/shared/default_sliver_scaffold.dart';
import 'package:contratacao_funcionarios/src/widgets/autocomplete_input.dart';
import 'package:contratacao_funcionarios/src/widgets/download_input_button.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:flutter/material.dart';
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
  GlobalKey<AutoCompleteTextFieldState<String>> _citieController;

  @override
  Widget build(BuildContext context) {
    _nomeInputController = TextEditingController();

    UserProviderModel _model = Provider.of<UserProviderModel>(context);
    AccountUserBloc _bloc = AccountUserBloc();
    _citieController = new GlobalKey();

    return DefaultSliverScaffold(
        titleScaffold: "Conta",
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Column(
                      children: <Widget>[
                        InputField(
                            _nomeInputController,
                            false,
                            TextInputType.emailAddress,
                            'Nome Completo',
                            [],
                            _bloc.outName,
                            _bloc.changeName,
                            'Nome conta',
                            false),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: _bloc.getCities(context),
                          builder:
                              (context, AsyncSnapshot<List<String>> snapshot) {
                            if (snapshot.connectionState.index ==
                                    ConnectionState.none.index ||
                                snapshot.connectionState.index ==
                                    ConnectionState.waiting.index) {
                              return Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  AutoCompleteInput(null, 'Cidade',_citieController),
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
                              return AutoCompleteInput(snapshot.data, 'Cidade',_citieController);
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
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DownloadInputButton(),
                        Text(
                          "Anexe o pdf do seu currículo.",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                    onPressed: () {
                      _model.userData
                          .putIfAbsent('name', () => _nomeInputController.text);
                      _model.userData.putIfAbsent(
                          'skills', () => _skillsInputController.text);
                      _model.userData.putIfAbsent('city',
                          () => _citieController.currentState.textSubmitted);

                      _bloc.saveController.add({});
                    },
                    color: Theme.of(context).hintColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.save,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'SALVAR',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
