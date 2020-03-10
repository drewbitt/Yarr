import 'package:flutter/material.dart';
import 'package:flutterroad/tabs/pages/components/ChapterPage.dart';
import 'package:royalroad_api/royalroad_api.dart';
import 'package:royalroad_api/src/models.dart' show BookChapter;

class Chapter extends StatelessWidget {
  final BookChapter bookChapter;

  Chapter(this.bookChapter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: ChapterPage(getChapter(bookChapter))));
  }
}
