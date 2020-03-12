import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/tabs/pages/components/NovelPage.dart';
import 'package:royalroad_api/models.dart' show BookSearchResult;

class NovelDetails extends StatelessBookBase {
  final BookSearchResult book;

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
