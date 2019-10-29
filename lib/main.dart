import 'package:contratacao_funcionarios/src/models/user_model.dart';
import 'package:contratacao_funcionarios/src/screens/login_page.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_user_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/contact_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/home_company_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());
final LoginPage myHomePage = LoginPage();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(
          value: UserModel(),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          const FallbackCupertinoLocalisationsDelegate(),
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        title: 'Contratação de Funcionários',
        theme: _getThemeData(),
        home: Consumer<UserModel>(
          builder: (context, controller, widget) {
            return LoginPage();
          },
        ),
        routes: {
          '/accountTab': (context) => Material(child: AccountUserTab()),
          '/contactTab': (context) => Scaffold(body: ContactTab()),
          '/homeCompanyTab': (context) => Scaffold(body: HomeCompanyTab()),
          '/loginPage': (context) => myHomePage,
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  ThemeData _getThemeData() {
    Color primary = Color.fromRGBO(14, 14, 14, 1);
    Color accent = Color.fromRGBO(4, 231, 98, 1);

    return ThemeData(
        primaryColor: primary,
        accentColor: accent,
        accentColorBrightness: Brightness.dark,
        backgroundColor: Colors.white,
        buttonColor: Color.fromRGBO(20, 33, 61, 1),
        errorColor: Color.fromRGBO(209, 0, 0, 1),
        scaffoldBackgroundColor: primary,
        cardColor: Color.fromRGBO(241, 241, 241, 1),
        primaryColorLight: Color.fromRGBO(30, 30, 30, 1),
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
            body2: TextStyle(fontSize: 14),
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

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
