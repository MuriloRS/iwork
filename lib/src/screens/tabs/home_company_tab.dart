import 'package:contratacao_funcionarios/src/blocs/company_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_company_tab.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeCompanyTab extends StatelessWidget {
  UserModel _model;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CompanyBloc bloc;
  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();
  static double avaliacaoMedia = 3.0;
  static String funcaoSelecionada = '';

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<UserModel>(context);
    bloc = CompanyBloc(_model.documentId);

    if (!_model.profileCompleted) {
      return AccountCompanyTab();
    }
    bloc.searchProfessionalController.add({
      'context': context,
      'funcao': null,
      'rating': null,
      'nameCompany': _model.name
    });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text(
              'Início',
              style: TextStyle(fontSize: 22),
            ),
            centerTitle: true,
            leading: IconButton(
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.white,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            bottom: PreferredSize(
                child: Container(
                  color: Colors.grey[700],
                  height: 1.0,
                ),
                preferredSize: Size.fromHeight(1.0))),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              FontAwesomeIcons.stream,
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Theme.of(context).accentColor,
            onPressed: () {
              _showFilterDialog(context);
            }),
        body: StreamBuilder(
          stream: bloc.outState,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == StateCurrent.LOADING ||
                !snapshot.hasData ||
                snapshot.connectionState.index == ConnectionState.none.index ||
                snapshot.connectionState.index ==
                    ConnectionState.waiting.index) {
              return Loader();
            } else {
              if (StateCurrent.EMPTY == snapshot.data) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Nenhum Profissional Encontrado, tente alterar o filtro.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                );
              } else {
                String msgQtdFuncionarios = '';

                if (bloc.listProfessionals.length == 1) {
                  msgQtdFuncionarios = '1 Profissional Encontrado';
                } else {
                  msgQtdFuncionarios =
                      bloc.listProfessionals.length.toString() +
                          ' Profissionais Encontrado';
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(msgQtdFuncionarios,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).cardColor, fontSize: 20)),
                    SizedBox(
                      height: 5,
                    ),
                    SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.only(
                                top: 15, left: 15, right: 15, bottom: 5),
                            height: MediaQuery.of(context).size.height - 135,
                            child: ListView.separated(
                              itemCount: bloc.listProfessionals.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 10,
                                );
                              },
                              itemBuilder: (context, index) {
                                return bloc.listProfessionals.elementAt(index);
                              },
                            )))
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }

  void _showFilterDialog(context) {
    TextEditingController funcaoController =
        TextEditingController(text: HomeCompanyTab.funcaoSelecionada);

    Alert(
        context: context,
        title: 'Filtro',
        style: AlertStyle(
            titleStyle: TextStyle(fontSize: 26), isOverlayTapDismiss: true),
        closeFunction: () {},
        buttons: [
          DialogButton(
            child: Text("Buscar",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            onPressed: () {
              bloc.doSearchProfessional.add({
                'context': context,
                'funcao':
                    funcaoController.text == '' ? null : funcaoController.text,
                'rating': avaliacaoMedia
              });

              Navigator.pop(context);
            },
            color: Theme.of(context).accentColor,
          )
        ],
        content: FormBuilder(
            key: fbKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Text("Função",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                FormBuilderTextField(
                  attribute: 'Função',
                  controller: funcaoController,
                  decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Theme.of(context).accentColor)),
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey[300]))),
                ),
                SizedBox(
                  height: 30,
                ),
                Text("Avaliação média",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                FormBuilderSlider(
                    min: 0.0,
                    max: 5.0,
                    divisions: 10,
                    initialValue: HomeCompanyTab.avaliacaoMedia,
                    validators: [],
                    onChanged: (newValue) {
                      avaliacaoMedia = newValue;
                    },
                    attribute: 'Avaliação média',
                    decoration: InputDecoration(
                        hintText: 'Avaliação média',
                        isDense: true,
                        fillColor: Colors.white,
                        border: InputBorder.none))
              ],
            ))).show();
  }
}
