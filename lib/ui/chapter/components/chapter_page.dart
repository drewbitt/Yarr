import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' show Html;
import 'package:flutter_html/style.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/services/localstorage_service.dart';
import 'package:flutterroad/ui/chapter/components/dialog_content.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:royalroad_api/models.dart' show AuthorNote, Chapter;
import 'package:slide_popup_dialog/slide_popup_dialog.dart';

class ChapterPage extends StatefulWidget {
  final Future<Chapter> chapterContentsFuture;
  ChapterPage(this.chapterContentsFuture);

  @override
  State<StatefulWidget> createState() =>
      _ChapterPageState(this.chapterContentsFuture);
}

class _ChapterPageState extends State<ChapterPage> {
  final Future<Chapter> chapterContentsFuture;
  _ChapterPageState(this.chapterContentsFuture);

  int _fontSize;
  int _fontSizeTitle;
  LocalStorageService _prefs;
  String _fontFamily;

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  _loadSharedPreferences() async {
    _prefs = getIt.get<LocalStorageService>();

    if (_prefs.containsKey('chapterFontSize')) {
      setState(() {
        _fontSize = _prefs.fontSize;
        _fontSizeTitle = _prefs.fontSize + 5;
      });
    } else {
      _prefs.fontSize = fontSizeChapterReader.toInt();
      setState(() {
        _fontSize = fontSizeChapterReader.toInt();
        _fontSizeTitle = fontSizeChapterReader.toInt() + 5;
      });
    }

    if (_prefs.containsKey('chapterFontFamily')) {
      _fontFamily = _prefs.fontFamily;
    } else {
      _prefs.fontFamily = 'Lora';
      setState(() {
        _fontFamily = 'Lora';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureBuilder<Chapter>(
        future: chapterContentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return _error();
            }
            if (snapshot.hasData) {
              final data = snapshot.data;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    BackButton(),
                    _title(data.title, theme: _theme),
                    GestureDetector(
                        onTap: () => _showDialog(data.id)
                            .then((value) => _loadSharedPreferences()),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: chapterSidePadding, right: chapterSidePadding, bottom: 15),
                            // useRichText fixes status screens, but is also ugly,
                            // just waiting on a fix from the library
                            child: Column(
                              children: <Widget>[
                                if (data.beginNote != null)
                                  _htmlAuthorNote(data.beginNote,
                                      theme: _theme),
                                Html(
                                  key: Key("chapter_contents"),
                                  data: data.contents,
                                  useRichText: true,
                                  defaultTextStyle: TextStyle(
                                      fontSize: _fontSize.toDouble(),
                                      height: fontSizeChapterLineHeight,
                                      fontFamily: _fontFamily),
                                ),
                                if (data.endNote != null)
                                  _htmlAuthorNote(data.endNote, theme: _theme)
                              ],
                            )))
                  ]);
            } else {
              return _loader();
            }
          } else {
            return _loader();
          }
        });
  }

  Future _showDialog(int id) =>
      showSlideDialog(context: context, child: DialogContent(id));

  Widget _title(title, {theme}) => Flexible(
      child: Padding(
          padding: EdgeInsets.fromLTRB(chapterSidePadding, 3, 15, chapterSidePadding),
          child: Text(title,
              style: TextStyle(
                  // color is to make title slighty darker than the text in light mode
                  color: theme.darkMode ? Colors.white : Colors.black,
                  fontSize: _fontSizeTitle.toDouble(),
                  fontFamily: _fontFamily),
              maxLines: 3,
              overflow: TextOverflow.ellipsis)));

  Widget _loader() => Container(
      height: MediaQuery.of(context).size.height,
      child: CupertinoActivityIndicator(radius: centerLoadingSpinnerRadius));

  Widget _error() => Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
          child: Text("Could not load chapter",
              style: TextStyle(fontSize: fontSizeMain))));

  /// Returns HTML display of the author note assuming one is present
  Widget _htmlAuthorNote(AuthorNote note, {theme}) => Html(
        data: '<b>' +
            note?.caption?.toUpperCase() +
            '</b><br /><br />' +
            note?.noteBody,
        style: {
          'html': Style(
              backgroundColor: theme.darkMode
                  ? Color.fromRGBO(35, 35, 35, 1)
                  : Color.fromRGBO(200, 200, 200, 1))
        },
      );
}
