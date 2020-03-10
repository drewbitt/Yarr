import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/tabs/pages/chapter.dart';
import 'package:royalroad_api/src/models.dart' show BookDetails;

class ChapterList extends StatelessWidget {
  final Future<BookDetails> chapterFuture;

  ChapterList(this.chapterFuture);

  // TODO: Refactor using pages - long novels are just terrible
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookDetails>(
      future: chapterFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final chapterList = snapshot.data.chapterList;
          minLength() => chapterList.length < 8 ? chapterList.length - 1 : 8;
          final chapterListPreview = chapterList.sublist(0, minLength() + 1);

          // Bad way to do this - two listviews
          return Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 40),
              child: ExpandablePanel(
                header: Text('Chapters',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 45)),
                collapsed: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: chapterListPreview.length,
                    itemBuilder: (context, index) {
                      return _buildPanel(chapterListPreview, index, context);
                    }),
                expanded: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: chapterList.length,
                    itemBuilder: (context, index) {
                      return _buildPanel(chapterList, index, context);
                    }),
              ));
        } else {
          // NOTE: This spinner will never time out
          return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: MediaQuery.of(context).size.width / 40),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: CupertinoActivityIndicator()),
                  Text("Getting chapters", style: TextStyle(fontSize: 15)),
                ],
              ));
        }
      },
    );
  }

  _buildPanel(chapterList, index, context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Text(chapterList[index].name,
                      overflow: TextOverflow.ellipsis)),
              Text(daysAgo(chapterList[index].releaseDate).toString() +
                  " days ago")
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Chapter(chapterList[index])));
          },
        ));
  }
}

// TODO: RR stores the string for months/days/years - maybe steal that?
daysAgo(DateTime d) => DateTime.now().difference(d).inDays;
