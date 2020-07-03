
import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:royalroad_api/models.dart';

class LibraryCard extends StatelessBookBase {
  final FictionListResult book;
  LibraryCard({this.book}) : super(book);

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           Expanded(
             child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: getImage(height: 150.0)),
           ),
          Text(this.book.book.title,
              style: TextStyle(
                  color: _theme.darkMode
                      ? darkModeTitleColor
                      : lightModeTitleColor,
                  fontSize: fontSizeMain),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ]);
  }

}