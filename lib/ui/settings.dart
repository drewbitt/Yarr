import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: <Widget>[DarkModeSwitch(), _clearCacheButton(context)],
      ),
    );
  }
}

_clearCacheButton(context) => ListTile(
      title: Text("Clear cached images"),
      onTap: () => clearDiskCachedImages().then((bool done) =>
          // TODO: in emulator, needs to be restarted before cache deletion takes effect.
          // See if true for real device, and if so, tell user to restart
          Fluttertoast.showToast(msg: done ? "Cleared cache": "Could not clear cache",
          toastLength: Toast.LENGTH_LONG)
      ));
