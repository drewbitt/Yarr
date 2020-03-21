import 'package:flutter/material.dart';
import 'package:flutterroad/ui/chapter/components/ChapterPage.dart';
import 'package:royalroad_api/models.dart' show BookChapter;
import 'package:royalroad_api/royalroad_api.dart';

class Chapter extends StatelessWidget {
  final BookChapter bookChapter;

  Chapter(this.bookChapter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
                children: <Widget>[ChapterPage(getChapter(bookChapter))])));
  }
}
