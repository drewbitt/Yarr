import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/services/localstorage_service.dart';
import 'package:flutterroad/ui/components/library_card.dart';
import 'package:flutterroad/ui/fiction/novel_details.dart';
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
    return GridView.builder(
        itemCount: _library.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.9),
        itemBuilder: (BuildContext context, int index) {
          final jsonBook = json.decode(_library[index]);
          final book = Fiction.fromJson(jsonBook);
          final bookListResult = FictionListResult(
              book: book,
              info: FictionListInfo(
                  genres: [],
                  followers: 0,
                  pages: 0,
                  chapters: 0,
                  views: 0,
                  rating: 0,
                  lastUpdate: null,
                  descriptionText: ""));
          return InkWell(
            child: LibraryCard(
              book: bookListResult,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NovelDetails(bookListResult)));
            },
          );
        });
  }
}
