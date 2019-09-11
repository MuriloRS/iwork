import 'package:contratacao_funcionarios/src/blocs/account_user_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/shared/combobox_button.dart';
import 'package:contratacao_funcionarios/src/shared/consumables.dart';
import 'package:contratacao_funcionarios/src/shared/default_sliver_scaffold.dart';
import 'package:contratacao_funcionarios/src/widgets/input_field.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AccountUserTab extends StatelessWidget {
  TextEditingController _nomeInputController;

  final consumable = Consumables();

  @override
  Widget build(BuildContext context) {
    _nomeInputController = TextEditingController();

    UserProviderModel _model = Provider.of<UserProviderModel>(context);
    AccountUserBloc _bloc = AccountUserBloc();

    return DefaultSliverScaffold(
        titleScaffold: "Conta",
        content: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    !_model.userData['profileCompleted']
                        ? Card(
                            color: Colors.green,
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Quase!",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Agora você precisa completar seu cadastro, " +
                                        "quanto mais informações você colocar mais " +
                                        "chances terá de conseguir trabalhos.",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ))
                        : Container(),
                    SizedBox(
                      height: 20,
                    ),
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
                    StreamBuilder(
                      stream: consumable.getBrazilianStates().asStream(),
                      builder: (context,
                          AsyncSnapshot<List<DropdownMenuItem>> builder) {
                        if (builder.connectionState.index ==
                                ConnectionState.none.index ||
                            builder.connectionState.index ==
                                ConnectionState.waiting.index) {
                          return Stack(
                            children: <Widget>[
                              ComboboxButton(
                                hintText: 'Estado',
                                options: null,
                              ),
                              Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green[600]),
                                ),
                              )
                            ],
                          );
                        } else {
                          return ComboboxButton(
                            hintText: "Estado",
                            options: builder.data,
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                        _nomeInputController,
                        false,
                        TextInputType.emailAddress,
                        'Cidade',
                        [],
                        _bloc.outName,
                        _bloc.changeName,
                        'cidade conta',
                        false),
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                        _nomeInputController,
                        false,
                        TextInputType.multiline,
                        'Experiências',
                        [],
                        _bloc.outName,
                        _bloc.changeName,
                        'experiencias conta',
                        false),
                    Text(
                      "Coloque apenas o que você já tem experiência. Separe por virgula, ex: mecânico, garçom.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InputField(
                        _nomeInputController,
                        false,
                        TextInputType.emailAddress,
                        'Currículo',
                        [],
                        _bloc.outName,
                        _bloc.changeName,
                        'curriculo conta',
                        false),
                    Text(
                      "Anexe o pdf do seu currículo.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                    onPressed: () => {},
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
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
