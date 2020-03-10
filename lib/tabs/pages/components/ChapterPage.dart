import 'package:flutter/material.dart';
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
            return RichText(
              text: TextSpan(text: data.contents),
            );
          } else {
            return Text("I'm loading here");
          }
        });
  }
}
