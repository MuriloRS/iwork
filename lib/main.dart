import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/login_page.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_user_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/contact_tab.dart';
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
        home: Consumer<UserProviderModel>(
          builder: (context, controller, widget) {
            return LoginPage();
          },
        ),
        routes: {
          '/accountTab': (context) => Material(child: AccountUserTab()),
          '/contactTab': (context) => Scaffold(body: ContactTab())
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _getThemeData() {
    Color primary = Color.fromRGBO(30, 32, 36, 1);
    Color accent = Color.fromRGBO(230, 226, 59, 1);

    return ThemeData(
        primaryColor: primary,
        accentColor: accent,
        backgroundColor: Colors.white,
        buttonColor: Color.fromRGBO(20, 33, 61, 1),
        errorColor: Color.fromRGBO(209, 0, 0, 1),
        scaffoldBackgroundColor: primary,
        cardColor: Color.fromRGBO(241, 241, 241, 1),
        primaryColorLight: Color.fromRGBO(45, 47, 51, 1),
        hintColor: Color.fromRGBO(4, 231, 91, 1),
        buttonTheme: ButtonThemeData(
          buttonColor: accent,
          highlightColor: primary,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        primaryTextTheme: TextTheme(
            subtitle: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w600, color: accent),
            title: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(241, 241, 241, 1))),
        accentTextTheme: TextTheme(
          title: TextStyle(
              fontSize: 28, color: primary, fontWeight: FontWeight.w700),
        ));
  }
}
