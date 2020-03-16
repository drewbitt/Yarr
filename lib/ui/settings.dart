import 'package:flutter/material.dart';
import 'package:persist_theme/persist_theme.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: DarkModeSwitch(),
    );
  }
}
