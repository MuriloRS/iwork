import 'package:contratacao_funcionarios/src/screens/tabs/account_company_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/company_contracts_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/contact_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/home_company_tab.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/how_works_tab.dart';
import 'package:contratacao_funcionarios/src/shared/drawer_company.dart';
import 'package:flutter/material.dart';

class HomeScreenCompany extends StatelessWidget {
  int initialPage;
  PageController _pageController;
  HomeScreenCompany(this.initialPage);

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: this.initialPage);
    return Container(
        color: Colors.white,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Scaffold(
              body: HomeCompanyTab(),
              drawer: DrawerCompany(_pageController),
            ),
            Scaffold(
              body: CompanyContractsTab(),
              drawer: DrawerCompany(_pageController),
            ),
            Scaffold(
              body: HowWorksTab(),
              drawer: DrawerCompany(_pageController),
            ),
            Scaffold(
              body: AccountCompanyTab(),
              drawer: DrawerCompany(_pageController),
            ),
            Scaffold(
              body: ContactTab(),
              drawer: DrawerCompany(_pageController),
            ),
          ],
        ));
  }
}
