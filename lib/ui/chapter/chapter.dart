import 'package:flutter/material.dart';
import 'package:flutterroad/ui/chapter/components/chapter_page.dart';
import 'package:royalroad_api/models.dart' show ChapterDetails;
import 'package:royalroad_api/royalroad_api.dart';

class Chapter extends StatelessWidget {
  final ChapterDetails bookChapter;

  Chapter(this.bookChapter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
                children: <Widget>[ChapterPage(getChapter(bookChapter))])));
  }
}
