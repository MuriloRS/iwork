import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  String title;

  CustomSliverAppbar(this.title);

  @override
  SliverAppBar build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      centerTitle: true,
      floating: true,
      backgroundColor: Colors.white,
      iconTheme:
          new IconThemeData(color: Theme.of(context).primaryColor, size: 26),
      elevation: 5.0,
      forceElevated: true,
      snap: true,
    );
  }
}
