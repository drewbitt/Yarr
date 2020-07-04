import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/services/localstorage_service.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatelessWidget {
  final _prefs = getIt.get<LocalStorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: <Widget>[
          DarkModeSwitch(),
          _clearCacheButton(),
          _clearLibraryButton()
        ],
      ),
    );
  }

  _clearCacheButton() => ListTile(
      title: Text("Clear cached images"),
      onTap: () => clearDiskCachedImages().then((bool done) =>
          // TODO: in emulator, needs to be restarted before cache deletion takes effect.
          // See if true for real device, and if so, tell user to restart
          Fluttertoast.showToast(
              msg: done ? "Cleared cache" : "Could not clear cache",
              toastLength: Toast.LENGTH_LONG)));

  _clearLibraryButton() => ListTile(
      title: Text("Clear all library fictions"),
      onTap: () {
        _prefs.library = [];
        Fluttertoast.showToast(
            msg: "Cleared all library fictions",
            toastLength: Toast.LENGTH_LONG);
      });
}
