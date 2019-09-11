import 'package:contratacao_funcionarios/src/shared/custom_sliver_appbar.dart';
import 'package:flutter/material.dart';

class DefaultSliverScaffold extends StatelessWidget {
  final String titleScaffold;
  final Widget content;

  DefaultSliverScaffold({@required this.titleScaffold,@required this.content});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: CustomScrollView(slivers: <Widget>[
      CustomSliverAppbar(titleScaffold),
      SliverToBoxAdapter(child: content)
    ]));
  }
}
