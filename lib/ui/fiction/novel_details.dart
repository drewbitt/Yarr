import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/ui/fiction/components/novel_page.dart';
import 'package:royalroad_api/models.dart' show FictionListResult;
import 'package:url_launcher/url_launcher.dart';

class NovelDetails extends StatelessBookBase {
  final FictionListResult book;

  NovelDetails(this.book) : super(book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            actions: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                      onTap: () => launch(this.book.book.url),
                      child: Icon(Icons.open_in_browser)))
            ],
          ),
          SliverList(delegate: SliverChildListDelegate([NovelPage(this.book)]))
        ],
      )),
    );
  }
}
