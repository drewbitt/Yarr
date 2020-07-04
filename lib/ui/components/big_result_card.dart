import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:intl/intl.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:royalroad_api/models.dart';

class BigResultCard extends StatelessBookBase {
  final FictionListResult book;
  final int index;

  BigResultCard(this.book, {@required this.index}) : super(book);

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('#' + (index + 1).toString() + ': ' + this.book.book.title,
              style: TextStyle(
                  color: _theme.darkMode
                      ? darkModeTitleColor
                      : lightModeTitleColor,
                  fontSize: fontSizeHeroNovelTitle),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: getImage(height: 200.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Icon(Icons.people, size: 22),
                    Text(this.book.info.followers.toString() + " Followers")
                  ]),
                  Row(children: <Widget>[
                    Icon(Icons.book, size: 22),
                    Text(this.book.info.pages.toString() + " Pages")
                  ]),
                  Row(children: <Widget>[
                    Icon(Icons.list, size: 22),
                    Text(this.book.info.chapters.toString() + " Chapters")
                  ])
                ],
              ),
              SizedBox(width: 30), // Padding
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Icon(Icons.star, size: 22),
                    Text(this.book.info.rating.toString() + " Stars")
                  ]),
                  Row(children: <Widget>[
                    Icon(Icons.visibility, size: 22),
                    Text(NumberFormat.compact()
                            .format(this.book.info.views)
                            .toString() +
                        " Views")
                  ]),
                  Row(children: <Widget>[
                    Icon(Icons.calendar_today, size: 22),
                    Text(DateFormat('MMM, d y')
                        .format(this.book.info.lastUpdate)
                        .toString())
                  ]),
                ],
              )
            ],
          )
        ]);
  }
}
