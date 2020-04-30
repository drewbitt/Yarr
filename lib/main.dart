import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/providers.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:flutterroad/ui/settings.dart';
import 'package:flutterroad/ui/tabs/home_tab.dart';
import 'package:flutterroad/ui/tabs/search_tab.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(providers());
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Yarr"),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                    child: Icon(
                      Icons.settings,
                      key: Key("settings"),
                    ),
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
