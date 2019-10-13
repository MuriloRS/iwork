import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  String title;

  CustomSliverAppbar(this.title);

  @override
  SliverAppBar build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).cardColor, fontSize: 22),
      ),
      bottom: PreferredSize(
          child: Container(
            color: Theme.of(context).primaryColorLight,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(4.0)),
      actionsIconTheme: IconThemeData(color: Theme.of(context).cardColor),
      centerTitle: true,
      floating: true,
      elevation: 5,
      forceElevated: true,
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme:
          new IconThemeData(color: Theme.of(context).cardColor, size: 22),
      snap: true,
    );
  }
}
