import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' show Html;
import 'package:royalroad_api/src/models.dart' show BookChapterContents;

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
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      // useRichText fixes status screens, but is also ugly,
                      // just waiting on a fix from the library
                      child: Html(data: data.contents, useRichText: true))
                ]);
          } else {
            return Text("I'm loading here");
          }
        });
  }
}
