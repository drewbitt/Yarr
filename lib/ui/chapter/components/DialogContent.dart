import 'package:flutter/material.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class DialogContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  int _fontSize = 15; // In testing this has been OK to set. Otherwise,
  // get a toDouble() error if the dialog loads too fast
  String _fontFamily = "Lora";
  SharedPreferences _prefs;
  var _listFonts = [
    FontListItem<String>("Default"),
    FontListItem<String>("Lora"),
    FontListItem<String>("Source Sans Pro")
  ];

  @override
  void initState() {
    super.initState();
    // Workaround to call an async function from initState()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSharedPreferences();
    });
  }

  _loadSharedPreferences() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    // Load state from sharedPreferences tool
    setState(() {
      _fontSize = _prefs.getInt('chapterFontSize');
      _fontFamily = _prefs.getString('chapterFontFamily');
      // Set state on the _listFonts element of the chapter family from sharedPreferences
      _listFonts
          .singleWhere((element) =>
              element.data == _prefs.getString('chapterFontFamily'))
          .isSelected = true;
    });
  }

  _buildDialog(context) {
    return Column(children: <Widget>[
      Text("Display settings", style: TextStyle(fontSize: 18)),
      _buildTextSizeSlider(context),
      _buildFontOptionList(context)
    ]);
  }

  _buildTextSizeSlider(context) => SliderTheme(
      data: SliderTheme.of(context).copyWith(
        tickMarkShape: RoundSliderTickMarkShape(),
        inactiveTickMarkColor: Provider.of<ThemeModel>(context).darkMode
            ? Colors.red[100]
            : Colors.red[400],
      ),
      child: Slider(
        min: 10,
        max: 30,
        value: _fontSize.toDouble(),
        divisions: 6,
        label: '$_fontSize',
        onChanged: (value) {
          // State allows the animation of it sliding to work
          setState(() {
            _fontSize = value.toInt();
            _prefs.setInt('chapterFontSize', value.toInt());
          });
        },
      ));

  _buildFontOptionList(context) =>
      ListView(shrinkWrap: true, children: <Widget>[
        _buildFontListItem(0),
        _buildFontListItem(1),
        _buildFontListItem(2),
      ]);

  _buildFontListItem(index) => GestureDetector(
      onTap: () {
        // Remove isSelected on the previous font choice
        _listFonts.asMap().forEach((index, element) {
          if (element.isSelected) {
            setState(() => _listFonts[index].isSelected = false);
          }
        });
        setState(() {
          _listFonts[index].isSelected = true;
          _prefs.setString('chapterFontFamily', _listFonts[index].data);
        });
      },
      child: Container(
          color: _listFonts[index].isSelected
              ? Theme.of(context).backgroundColor
              : null,
          child: ListTile(title: Text(_listFonts[index].data))));

  @override
  Widget build(BuildContext context) {
    return _buildDialog(context);
  }
}

/// Class used in fontList to have an isSelected property
class FontListItem<String> {
  bool isSelected = false;
  String data;
  FontListItem(this.data);
}
