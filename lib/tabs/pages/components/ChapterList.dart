import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/tabs/pages/chapter.dart';
import 'package:royalroad_api/src/models.dart' show BookDetails;

class ChapterList extends StatelessWidget {
  final Future<BookDetails> chapterListFuture;

  ChapterList(this.chapterListFuture);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookDetails>(
      future: chapterListFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final chapterList = snapshot.data.chapterList;
          minLength() => chapterList.length < 8 ? chapterList.length-1 : 8;
          final chapterListPreview = chapterList.sublist(0, minLength());

          // Bad way to do this - two listviews
          return
            ExpandablePanel(
            header: Text('Chapters'),
            collapsed:
              ListView.builder(
              shrinkWrap: true,
              itemCount: chapterListPreview.length,
              itemBuilder: (context, index) {
                return _buildPanel(chapterListPreview, index, context);
              }),
            expanded: ListView.builder(
                shrinkWrap: true,
                itemCount: chapterList.length,
                itemBuilder: (context, index) {
                  return _buildPanel(chapterList, index, context);
                }),
          );
        } else {
          // TODO: This will show up at first page load... but also if it never works...
          return Text("Getting chapters");
        }
      },
    );
  }
  _buildPanel(chapterList, index, context) {
    return
      Padding(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child:
              InkWell(
                  child: Text(chapterList[index].name, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Chapter(chapterList[index])));
                  }),
              ),
              Text(
                  daysAgo(chapterList[index].releaseDate).toString() +
                      " days ago")
            ],
          ));
  }

  // TODO: RR stores the string for months/days/years - maybe steal that?
  daysAgo(DateTime d) => DateTime.now().difference(d).inDays;
}
