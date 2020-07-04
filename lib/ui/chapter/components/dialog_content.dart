import 'package:flutter/material.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/services/localstorage_service.dart';
import 'package:flutterroad/ui/chapter/comments/chapter_comments.dart';
import 'package:flutterroad/ui/chapter/components/dialog_round_item.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogContent extends StatefulWidget {
  final int id;
  final String chapUrl;

  DialogContent({this.id, this.chapUrl});

  @override
  State<StatefulWidget> createState() =>
      _DialogContentState(id: id, chapUrl: chapUrl);
}

class _DialogContentState extends State<DialogContent> {
  final int id;
  final String chapUrl;
  double _fontSize;
  LocalStorageService _prefs;

  _DialogContentState({this.id, this.chapUrl});

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

  Widget _dialog() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Text("Display settings",
              style: TextStyle(fontSize: fontSizeNovelSlideUpTitle)),
          DialogRoundedItem(child: _textSizeSlider(), title: "Text size"),
          SizedBox(height: 10),
          DialogRoundedItem(child: _fontOptionList(), title: "Font family"),
          Padding(
              padding: EdgeInsets.only(left: dialogListItemLeftPadding),
              child: Column(
                children: <Widget>[_commentsOption(id)],
              )),
          Padding(
              padding: EdgeInsets.only(left: dialogListItemLeftPadding),
              child: Column(
                children: <Widget>[_chapterLink()],
              )),
        ]),
      ),
    );
  }

  _textSizeSlider() => SliderTheme(
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

  Widget _fontOptionList() => MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          // TODO: Since not scrollable, convert to Column?
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _fontListItem(0),
            _fontListItem(1),
            _fontListItem(2),
          ]));

  Widget _fontListItem(index) => GestureDetector(
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

  Widget _commentsOption(int id) => ListTile(
      key: Key("chapter_comments_btn"),
      leading: Icon(Icons.comment, size: itemIconSize),
      title: Text('Chapter Comments'),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ChapterComments(id))));

  Widget _chapterLink() => ListTile(
      leading: Icon(Icons.open_in_browser, size: itemIconSize),
      title: Text('Open chapter in browser'),
      onTap: () => launch(chapUrl));

  @override
  Widget build(BuildContext context) {
    return _dialog();
  }
}

/// Class used in fontList to have an isSelected property
class FontListItem<String> {
  bool isSelected = false;
  String data;
  FontListItem(this.data);
}
