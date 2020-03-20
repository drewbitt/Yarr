import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' show Html;
import 'package:flutter_html/style.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:royalroad_api/models.dart' show AuthorNote, BookChapterContents;
import 'package:provider/provider.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart';

class ChapterPage extends StatefulWidget {
  final Future<BookChapterContents> chapterContentsFuture;
  ChapterPage(this.chapterContentsFuture);

  @override
  State<StatefulWidget> createState() =>
      _ChapterPageState(this.chapterContentsFuture);
}

class _ChapterPageState extends State<ChapterPage> {
  final Future<BookChapterContents> chapterContentsFuture;
  _ChapterPageState(this.chapterContentsFuture);

  static var _fontSize = 15;
  static var _fontSizeTitle = _fontSize + 5;

  _showDialog(context) {
    showSlideDialog(context: context, child: _buildDialog(context));
  }

  _buildDialog(context) {
    return Column(children: <Widget>[
      Text("Display settings", style: TextStyle(fontSize: 18)),
      Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 25), // this will need adjusting
              child: Text("Text size", style: TextStyle(fontSize: 16)))
        ],
      ),
      _buildTextSizeSlider(context)
    ]);
  }

  _buildTextSizeSlider(context) => SliderTheme(
      data: SliderTheme.of(context).copyWith(
        tickMarkShape: RoundSliderTickMarkShape(),
        inactiveTickMarkColor: Colors.red[100],
      ),
      child: Slider(
        min: 10,
        max: 30,
        value: _fontSize.toDouble(),
        divisions: 4,
        label: '$_fontSize',
        onChanged: (value) {
          setState(() {
            _fontSize = value.toInt();
            _fontSizeTitle = _fontSize + 5;
          });
        },
      ));

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureBuilder<BookChapterContents>(
        future: chapterContentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return _buildError(context);
            }
            if (snapshot.hasData) {
              final data = snapshot.data;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    BackButton(),
                    _buildTitle(data.title, theme: _theme),
                    GestureDetector(
                        onTap: () => _showDialog(context),
                        child: Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, bottom: 5),
                            // useRichText fixes status screens, but is also ugly,
                            // just waiting on a fix from the library
                            child: Column(
                              children: <Widget>[
                                _htmlAuthorNote(data.note, theme: _theme),
                                Html(
                                  data: data.contents,
                                  useRichText: true,
                                  defaultTextStyle:
                                      TextStyle(fontSize: _fontSize.toDouble()),
                                ),
                              ],
                            )))
                  ]);
            } else {
              return _buildLoader(context);
            }
          } else {
            return _buildLoader(context);
          }
        });
  }

  _buildTitle(title, {theme}) => Flexible(
      child: Padding(
          padding: EdgeInsets.fromLTRB(15, 3, 15, 15),
          child: Text(title,
              style: TextStyle(
                  color: theme.darkMode ? Colors.white : Colors.black,
                  fontSize: _fontSizeTitle.toDouble()),
              maxLines: 3,
              overflow: TextOverflow.ellipsis)));

  _buildLoader(context) => Container(
      height: MediaQuery.of(context).size.height,
      child: CupertinoActivityIndicator(radius: 15));

  _buildError(context) => Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
          child:
              Text("Could not load chapter", style: TextStyle(fontSize: 15))));

  /// Returns HTML display of the author note if present. Otherwise, an empty container.
  _htmlAuthorNote(AuthorNote note, {theme}) {
    if (note == null) {
      return Container();
    } else {
      return Html(
        data: '<b>' +
            note.caption.toUpperCase() +
            '</b><br /><br />' +
            note.noteBody,
        style: {
          'html': Style(
              backgroundColor: theme.darkMode
                  ? Color.fromRGBO(35, 35, 35, 1)
                  : Color.fromRGBO(200, 200, 200, 1))
        },
      );
    }
  }
}
