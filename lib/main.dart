import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/login_page.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_user_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/contact_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/home_company_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        title: 'Contratação de Funcionários',
        theme: _getThemeData(),
        home: Consumer<UserProviderModel>(
          builder: (context, controller, widget) {
            return LoginPage();
          },
        ),
        routes: {
          '/accountTab': (context) => Material(child: AccountUserTab()),
          '/contactTab': (context) => Scaffold(body: ContactTab()),
          '/homeCompanyTab': (context) => Scaffold(body: HomeCompanyTab())
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _getThemeData() {
    Color primary = Color.fromRGBO(30, 32, 36, 1);
    Color accent = Color.fromRGBO(4, 231, 98, 1);

    return ThemeData(
        primaryColor: primary,
        accentColor: accent,
        backgroundColor: Colors.white,
        buttonColor: Color.fromRGBO(20, 33, 61, 1),
        errorColor: Color.fromRGBO(209, 0, 0, 1),
        scaffoldBackgroundColor: primary,
        cardColor: Color.fromRGBO(241, 241, 241, 1),
        primaryColorLight: Color.fromRGBO(45, 47, 51, 1),
        inputDecorationTheme: InputDecorationTheme(
          focusedErrorBorder:
              OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          errorBorder:
              OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          filled: true,
          fillColor: const Color.fromRGBO(245, 245, 245, 1),
          hintStyle: TextStyle(color: Colors.grey[600]),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          focusedBorder: OutlineInputBorder(
            borderSide:
                new BorderSide(color: const Color.fromRGBO(230, 230, 230, 1)),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(3),
                bottomLeft: Radius.circular(3)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(3),
                bottomLeft: Radius.circular(3)),
          ),
        ),
        hintColor: Color.fromRGBO(230, 225, 100, 1),
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
