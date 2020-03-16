import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/ui/fiction/components/NovelPage.dart';
import 'package:royalroad_api/models.dart' show BookListResult;

class NovelDetails extends StatelessBookBase {
  final BookListResult book;

  NovelDetails(this.book) : super(book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(floating: true),
          SliverList(delegate: SliverChildListDelegate([NovelPage(this.book)]))
        ],
      )),
    );
  }
}
