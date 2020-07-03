import 'package:flutter/material.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/services/localstorage_service.dart';

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
        _library = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_library.toString());
  }
}
