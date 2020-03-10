import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' show Html;
import 'package:royalroad_api/models.dart' show BookChapterContents;

class ChapterPage extends StatelessWidget {
  final Future<BookChapterContents> chapterContentsFuture;

  ChapterPage(this.chapterContentsFuture);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookChapterContents>(
        future: chapterContentsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Flexible(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(6, 3, 6, 0),
                          child: Text(data.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 43),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis))),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      // useRichText fixes status screens, but is also ugly,
                      // just waiting on a fix from the library
                      child: Html(data: data.contents, useRichText: true))
                ]);
          } else {
            // NOTE: This spinner will never time out
            return Container(
                height: MediaQuery.of(context).size.height,
                child: CupertinoActivityIndicator(radius: 15));
          }
        });
  }
}
