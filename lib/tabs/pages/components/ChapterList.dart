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

          return ListView.builder(
              shrinkWrap: true,
              itemCount: chapterList.length,
              itemBuilder: (context, index) {
                return Row(
                    children: <Widget>[
                  InkWell(
                      child: Text(chapterList[index].name),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Chapter(chapterList[index])));
                      }),
                  SizedBox(width: MediaQuery.of(context).size.width / 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(daysAgo(chapterList[index].releaseDate).toString() + " days ago")
                    ],
                  )
                ]);
              });
        }
        else {
          // TODO: This will show up at first page load... but also if it never works...
          return Text("Getting chapters");
        }
      },
    );
  }

  daysAgo(DateTime d) => DateTime.now().difference(d).inDays;
}
