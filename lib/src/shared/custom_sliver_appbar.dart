import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  String title;

  CustomSliverAppbar(this.title);

  @override
  SliverAppBar build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).cardColor, fontSize: 24),
      ),
      bottom: PreferredSize(
          child: Container(
            color: Colors.grey[400],
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(4.0)),
      actionsIconTheme: IconThemeData(color: Theme.of(context).cardColor),
      centerTitle: true,
      floating: true,
      elevation: 3,
      forceElevated: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme:
          new IconThemeData(color: Theme.of(context).cardColor, size: 24),
      snap: true,
    );
  }
}
