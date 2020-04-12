import 'package:flutter/material.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/services/localstorage_service.dart';
import 'package:flutterroad/ui/chapter/comments/chapter_comments.dart';
import 'package:flutterroad/ui/chapter/components/dialog_round_item.dart';
import 'package:flutterroad/ui/constants.dart';

class DialogContent extends StatefulWidget {
  final int id;

  DialogContent(this.id);

  @override
  State<StatefulWidget> createState() => _DialogContentState(id);
}

class _DialogContentState extends State<DialogContent> {
  final int id;
  double _fontSize;
  LocalStorageService _prefs;

  _DialogContentState(this.id);

  var _listFonts = [
    FontListItem<String>("Default"),
    FontListItem<String>("Lora"),
    FontListItem<String>("Source Sans Pro")
  ];

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  _loadSharedPreferences() {
    // Load from sharedPreferences tool
    _prefs = getIt.get<LocalStorageService>();
    setState(() {
      _fontSize = _prefs.fontSize.toDouble();
      // Set state on the _listFonts element of the chapter family from sharedPreferences
      _listFonts
          .singleWhere((element) => element.data == _prefs.fontFamily)
          .isSelected = true;
    });
  }

  _buildDialog() {
    return Column(children: <Widget>[
      Text("Display settings",
          style: TextStyle(fontSize: fontSizeNovelSlideUpTitle)),
      DialogRoundedItem(child: _buildTextSizeSlider(), title: "Text size"),
      SizedBox(height: 10),
      DialogRoundedItem(child: _buildFontOptionList(), title: "Font family"),
      Padding(
          padding: EdgeInsets.only(left: dialogListItemLeftPadding),
          child: Column(
            children: <Widget>[_buildCommentsOption(id)],
          ))
    ]);
  }

  _buildTextSizeSlider() => SliderTheme(
      data: SliderTheme.of(context).copyWith(
          tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 1.5),
          // Manual color specification because it is always filling in these colors anyway on my devices
          // despite me not knowing why. Not gonna leave color on other devices to chance due to checkmark color
          activeTrackColor: Colors.blue,
          activeTickMarkColor: Colors.blue,
          inactiveTickMarkColor: Colors.blue.withAlpha(255 ~/ 2),
          inactiveTrackColor: Colors.blue.withAlpha(255 ~/ 4)),
      child: Slider(
        min: 10,
        max: 31,
        value: _fontSize,
        divisions: 7,
        label: _fontSize.toInt().toString(),
        onChanged: (value) {
          // State allows the animation of it sliding to work
          setState(() {
            _fontSize = value;
            _prefs.fontSize = value.toInt();
          });
        },
      ));

  _buildFontOptionList() => MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          // TODO: Since not scrollable, convert to Column?
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
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
          _prefs.fontFamily = _listFonts[index].data;
        });
      },
      child: Container(
          child: ListTile(
              title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_listFonts[index].data),
          if (_listFonts[index].isSelected)
            // Match color with slider
            /*
            Bug: I can never get the slider theme colors to ever return anything but null.
            When it's null in the SliderTheme in _buildTextSizeSlider, it eventually becomes Colors.blue,
            (but when accessing property, its null), and I have no idea why. Only found out with a color picker.
            */
            // SliderTheme.of(context).activeTrackColor
            Icon(Icons.check, color: Colors.blue)
        ],
      ))));

  _buildCommentsOption(int id) => ListTile(
      key: Key("chapter_comments_btn"),
      leading: Icon(Icons.comment, size: dialogListItemIconSize),
      title: Text('Chapter Comments'),
      onTap: () => _goToChapterComments());

  _goToChapterComments() => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => ChapterComments(id)));

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
