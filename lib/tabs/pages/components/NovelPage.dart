import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/tabs/pages/components/ChapterList.dart';
import 'package:royalroad_api/models.dart' show BookSearchResult;
import 'package:royalroad_api/royalroad_api.dart' show getBookDetails;

class NovelPage extends StatelessBookBase {
  final BookSearchResult book;

  NovelPage(this.book) : super(book);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 40,
                      MediaQuery.of(context).size.width / 40,
                      0,
                      0),
                  child: Column(
                    children: <Widget>[
                      getImage(MediaQuery.of(context).size.height / 3)
                    ],
                  )),
              Flexible(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(this.book.title,
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: MediaQuery.of(context).size.height / 40),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis),
              ))
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 120), // Padding
          Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 40),
              child: ExpandablePanel(
                header: Text('Description',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45)),
                collapsed: Text(
                  this.book.info.description,
                  softWrap: true,
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded: Text(
                  this.book.info.description,
                  softWrap: true,
                ),
              )),
          ChapterList(getBookDetails(this.book.url)),
        ]);
  }
}
