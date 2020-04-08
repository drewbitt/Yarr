import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/ui/chapter/comments/components/comment_page.dart';

class ChapterComments extends StatelessWidget {
  final int id;

  ChapterComments(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: CommentPage(id)));
  }
}
