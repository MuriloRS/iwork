import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/login_page.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_user_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProviderModel>.value(
          value: UserProviderModel(),
        )
      ],
      child: MaterialApp(
        title: 'Contratação de Funcionários',
        theme: _getThemeData(),
        home: SafeArea(child: Consumer<UserProviderModel>(
          builder: (context, controller, widget) {
            
            return LoginPage();
          },
        )),
        routes: {'/accountTab': (context) => Material(child: AccountUserTab())},
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _getThemeData() {
    Color primary = Color.fromRGBO(20, 33, 61, 1);

    return ThemeData(
        primaryColor: primary,
        accentColor: Color.fromRGBO(252, 163, 17, 1),
        backgroundColor: Colors.white,
        buttonColor: Color.fromRGBO(20, 33, 61, 1),
        errorColor: Color.fromRGBO(245, 0, 25, 1),
        scaffoldBackgroundColor: Colors.white,
        hintColor: Color.fromRGBO(221, 28, 26, 1),
        accentTextTheme: TextTheme(
          title: TextStyle(
              fontSize: 28, color: primary, fontWeight: FontWeight.w700),
        ));
  }
}
