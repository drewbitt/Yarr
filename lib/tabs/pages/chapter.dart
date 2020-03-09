import 'package:flutter/material.dart';
import 'package:royalroad_api/src/models.dart' show BookChapter;

class Chapter extends StatelessWidget {
  BookChapter bookChapter;

  Chapter(this.bookChapter);

  @override
  Widget build(BuildContext context) {
    return Text("Test");
  }

}