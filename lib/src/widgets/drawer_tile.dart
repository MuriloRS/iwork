import "package:flutter/material.dart";

class DrawerTile extends StatelessWidget {
  final PageController pageController;
  final IconData icon;
  final String text;
  final int page;

  DrawerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              pageController.jumpToPage(this.page);
            },
            child: Container(
              padding: EdgeInsets.only(left: 25),
              color: pageController.page.round() == this.page
                  ? Theme.of(context).primaryColorLight
                  : Colors.transparent,
              height: 60.0,
              child: Row(
                children: <Widget>[
                  Icon(icon,
                      size: 18.0,
                      color: pageController.page.round() == this.page
                          ? Theme.of(context).cardColor
                          : Color.fromRGBO(99, 101, 105, 1)),
                  SizedBox(
                    width: 24.0,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: pageController.page.round() == this.page
                            ? Theme.of(context).cardColor
                            : Color.fromRGBO(99, 101, 105, 1)),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
