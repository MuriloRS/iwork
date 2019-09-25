import 'package:contratacao_funcionarios/src/screens/tabs/account_user_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/contact_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/home_user_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/how_works_tab.dart';
import 'package:contratacao_funcionarios/src/shared/drawer_user.dart';
import 'package:flutter/material.dart';

class HomeScreenUser extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Scaffold(
              body: HomeUserTab(_pageController),
              drawer: DrawerUser(_pageController),
            ),
            Scaffold(
              body: HowWorksTab(),
              drawer: DrawerUser(_pageController),
            ),
            Scaffold(
              body: AccountUserTab(),
              drawer: DrawerUser(_pageController),
            ),
            Scaffold(
              body: ContactTab(),
              drawer: DrawerUser(_pageController),
            ),
          ],
        ));
  }
}
