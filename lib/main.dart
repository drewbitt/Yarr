import 'package:flutter/material.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:flutterroad/ui/settings.dart';
import 'package:flutterroad/ui/tabs/home_tab.dart';
import 'package:flutterroad/ui/tabs/search_tab.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';

final _model = ThemeModel(
    customDarkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(color: darkModeAppBarColor)),
    customLightTheme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(color: lightModeAppBarColor)));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(ListenableProvider<ThemeModel>(
      create: (_) => _model..init(),
      child: Consumer<ThemeModel>(builder: (context, model, child) {
        return MaterialApp(
            title: "FlutterRoad", theme: model.theme, home: MyHome());
      })));
}

class MyHome extends StatefulWidget {
  @override
  MyHomeState createState() => MyHomeState();
}

// SingleTickerProviderStateMixin is used for animation
class MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[HomeTab(), SearchTab()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("FlutterRoad"),
//          backgroundColor:
//              _theme.darkMode ? darkModeAppBarColor : lightModeAppBarColor,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                    child: Icon(Icons.settings),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Settings()));
                    }))
          ],
        ),
        body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), title: Text('Search'))
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
  }
}
