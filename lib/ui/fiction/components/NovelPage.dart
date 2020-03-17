import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/ui/chapter/components/ChapterList.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:royalroad_api/models.dart' show BookListResult;
import 'package:royalroad_api/royalroad_api.dart' show getFictionDetails;
import 'package:provider/provider.dart';

class NovelPage extends StatelessBookBase {
  final BookListResult book;

  NovelPage(this.book) : super(book);

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: Column(
                    children: <Widget>[getImage(height: 250.0)],
                  )),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.only(left: 15, right: 6),
                child: Text(this.book.book.title,
                    style: TextStyle(
                        color: _theme.darkMode
                            ? Colors.brown.shade300
                            : Colors.brown,
                        fontSize: 19),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis),
              ))
            ],
          ),
          SizedBox(height: 6), // Padding
          _buildDescription(_theme, book),
          ChapterList(getFictionDetails(this.book.book.url)),
        ]);
  }
}

_buildDescription(_theme, book) => Container(
    padding: EdgeInsets.all(10),
    child: ExpandablePanel(
        header: Text('Description', style: TextStyle(fontSize: 16)),
        collapsed: Text(
          book.info.description,
          softWrap: true,
          maxLines: 7,
          overflow: TextOverflow.ellipsis,
        ),
        expanded: Text(
          book.info.description,
          softWrap: true,
        ),
        iconColor: _theme.darkMode ? Colors.white54 : Colors.black54));
