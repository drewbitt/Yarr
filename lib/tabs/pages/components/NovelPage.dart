import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/tabs/pages/chapter.dart';
import 'package:flutterroad/tabs/pages/components/ChapterList.dart';
import 'package:royalroad_api/src/models.dart' show BookSearchResult;
import 'package:royalroad_api/royalroad_api.dart' show getBookDetails;

class NovelPage extends StatelessBookBase {
  final BookSearchResult book;

  NovelPage(this.book) : super(book);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Row(
            children: <Widget>[
              SizedBox(width: MediaQuery.of(context).size.width / 40),
              Column(
                children: <Widget>[
                  getImage(MediaQuery.of(context).size.height / 3)
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width / 40),
              Flexible(
                child: Text(this.book.title,
                    style: TextStyle(
                        color: Colors.brown,
                        fontSize: MediaQuery.of(context).size.height / 40),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 120),
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


