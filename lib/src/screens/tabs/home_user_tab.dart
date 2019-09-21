import 'package:contratacao_funcionarios/src/models/user_provider_model.dart';
import 'package:contratacao_funcionarios/src/screens/tabs/account_user_tab.dart';
import 'package:contratacao_funcionarios/src/shared/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeUserTab extends StatelessWidget {
  final PageController pageController;

  HomeUserTab(this.pageController);

  @override
  Widget build(BuildContext context) {
    UserProviderModel _model = Provider.of<UserProviderModel>(context);

    if (!_model.userData['profileCompleted']) {
      return AccountUserTab();
    }

    return SafeArea(
        child: CustomScrollView(slivers: <Widget>[
      CustomSliverAppbar("Início"),
      SliverToBoxAdapter(
        child: Container(
          child: Text("Tela inicial"),
          color: Colors.white,
        ),
      )
    ]));
  }
}