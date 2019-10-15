import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratacao_funcionarios/src/blocs/company_bloc.dart';
import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/company_screens.dart/user_detail_screen.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_company_tab.dart';
import 'package:contratacao_funcionarios/src/shared/alerts.dart';
import 'package:contratacao_funcionarios/src/widgets/button_input.dart';
import 'package:contratacao_funcionarios/src/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:swipe_stack/swipe_stack.dart';

class HomeCompanyTab extends StatelessWidget {
  UserProviderModel _model;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormBuilderState> _fbkey = new GlobalKey<FormBuilderState>();
  final CompanyBloc bloc = CompanyBloc();

  final GlobalKey<FormBuilderState> fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    _model = Provider.of<UserProviderModel>(context);

    if (!_model.userData['profileCompleted']) {
      return AccountCompanyTab();
    }

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
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
          height: MediaQuery.of(context).size.height - 80,
          child: Center(
            child: FutureBuilder(
              future: bloc.searchProfessionals(context),
              builder: (context, AsyncSnapshot<List<SwiperItem>> snapshot) {
                if (snapshot.connectionState.index ==
                        ConnectionState.none.index ||
                    snapshot.connectionState.index ==
                        ConnectionState.waiting.index) {
                  return Loader();
                } else {
                  SwipeStack(
                    children: snapshot.data,
                    visibleCount: 3,
                    stackFrom: StackFrom.Top,
                    translationInterval: 6,
                    scaleInterval: 0.03,
                    onEnd: () => debugPrint("onEnd"),
                    onSwipe: (int index, SwiperPosition position) =>
                        debugPrint("onSwipe $index $position"),
                    onRewind: (int index, SwiperPosition position) =>
                        debugPrint("onRewind $index $position"),
                  );
                }
              },
            ),
          ),
        )),
      ),
    );
  }

  void _showFilterDialog(context) {
    TextEditingController funcaoController = TextEditingController();

    Alert(
        context: context,
        title: 'Filtro',
        style: AlertStyle(titleStyle: TextStyle(fontSize: 26)),
        buttons: [
          DialogButton(
            child: Text("Buscar",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            onPressed: () {},
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
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                FormBuilderSlider(
                    min: 0.0,
                    max: 5.0,
                    divisions: 10,
                    initialValue: 3.0,
                    attribute: 'Avaliação média',
                    decoration: InputDecoration(
                        hintText: 'Avaliação média',
                        isDense: true,
                        fillColor: Colors.grey[150],
                        border: InputBorder.none))
              ],
            ))).show();
  }
}
