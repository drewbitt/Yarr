import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/services/localstorage_service.dart';
import 'package:flutterroad/ui/components/library_card.dart';
import 'package:flutterroad/ui/fiction/novel_details.dart';
import 'package:flutterroad/util.dart';
import 'package:royalroad_api/models.dart';

class LibraryTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LibraryTabState();
}

class LibraryTabState extends State<LibraryTab> {
  LocalStorageService _prefs;
  List<String> _library;

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  _loadSharedPreferences() async {
    _prefs = getIt.get<LocalStorageService>();

    if (_prefs.containsKey('library')) {
      setState(() {
        _library = _prefs.library;
      });
    } else {
      _prefs.library = [];
      setState(() {
        setState(() {
          _library = [];
        });
      });
    }
    _prefs.addListener(() {
      setState(() {
        _library = _prefs.library;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: _library.length == 0
          ? _emptyText()
          : GridView.builder(
              itemCount: _library.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 0.6),
              itemBuilder: (BuildContext context, int index) {
                final book = convertFictionJsonToFiction(_library[index]);
                final bookListResult =
                    FictionListResult(book: book, info: null);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    child: LibraryCard(
                      book: bookListResult,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NovelDetails(bookListResult)));
                    },
                  ),
                );
              }),
    );
  }

  Widget _emptyText() => Center(child: Text("No fictions in library"));
}
