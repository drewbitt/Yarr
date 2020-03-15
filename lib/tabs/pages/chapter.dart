import 'package:flutter/material.dart';
import 'package:flutterroad/tabs/pages/components/ChapterPage.dart';
import 'package:royalroad_api/royalroad_api.dart';
import 'package:royalroad_api/models.dart' show BookChapter;

class Chapter extends StatelessWidget {
  final BookChapter bookChapter;

  Chapter(this.bookChapter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Scrollbar(
                child: ListView(
                    // key: PageStorageKey('chapterPage'),
                    children: <Widget>[
          ChapterPage(getChapter(bookChapter))
        ]))));
  }
}
