import 'package:flutter/material.dart';
import 'package:flutterroad/ui/chapter/components/DialogRoundedItem.dart';
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

  _buildDialog() {
    return Column(children: <Widget>[
      Text("Display settings", style: TextStyle(fontSize: 18)),
      DialogRoundedItem(child: _buildTextSizeSlider(), title: "Text size"),
      SizedBox(height: 10),
      DialogRoundedItem(child: _buildFontOptionList(), title: "Font family")
    ]);
  }

  _buildTextSizeSlider() => SliderTheme(
      data: SliderTheme.of(context)
          .copyWith(tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 1.5)),
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

  _buildFontOptionList() => MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(shrinkWrap: true, children: <Widget>[
        _buildFontListItem(0),
        _buildFontListItem(1),
        _buildFontListItem(2),
      ]));

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
          child: ListTile(
              title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_listFonts[index].data),
          _listFonts[index].isSelected
              /* Bug here: wanting to match the color of the slider. That's the theme's primary color.
              // However, in dark mode, the slider still returns the primary color of light mode (Colors.blue)
              // Forcing Colors.blue here for both modes
              */
              ? Icon(Icons.check, color: Colors.blue)
              : Container()
        ],
      ))));

  @override
  Widget build(BuildContext context) {
    return _buildDialog();
  }
}

/// Class used in fontList to have an isSelected property
class FontListItem<String> {
  bool isSelected = false;
  String data;
  FontListItem(this.data);
}
