import 'package:flutter/material.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';

class DialogRoundedItem extends StatelessWidget {
  final Widget child;
  final String title;

  DialogRoundedItem({@required this.child, @required this.title});

  _getColor(context) => Provider.of<ThemeModel>(context).darkMode
      ? dialogItemBackgroundDark
      : dialogItemBackgroundLight;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(bottom: 8),
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                title,
                style: TextStyle(fontSize: fontSizeMain),
              )),
        ],
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: _getColor(context),
              border: Border.all(color: Theme.of(context).canvasColor),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          child: child,
        ),
      ])
    ]);
  }
}
