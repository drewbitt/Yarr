import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/main.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';

final _model = ThemeModel(
    customDarkTheme: ThemeData(
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(color: darkModeAppBarColor),
      cupertinoOverrideTheme:
          const CupertinoThemeData(brightness: Brightness.dark),
    ),
    customLightTheme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(color: lightModeAppBarColor)));

MultiProvider providers() => MultiProvider(
        providers: [
          ListenableProvider<ThemeModel>(create: (_) => _model..init()),
        ],
        child: Consumer<ThemeModel>(builder: (context, model, child) {
          return MaterialApp(title: "Yarr", theme: model.theme, home: MyHome());
        }));
