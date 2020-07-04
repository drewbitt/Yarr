import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutterroad/base/BookBaseState.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:flutterroad/ui/fiction/components/chapter_list.dart';
import 'package:flutterroad/util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:royalroad_api/models.dart'
    show FictionListResult, FictionDetails;
import 'package:royalroad_api/royalroad_api.dart' show getFictionDetails;
import 'package:url_launcher/url_launcher.dart';

class NovelPage extends StatefulWidget {
  final FictionListResult book;

  NovelPage(this.book);

  @override
  _NovelPageState createState() => _NovelPageState(book);
}

class _NovelPageState extends BookBaseState<NovelPage> {
  final FictionListResult book;
  _NovelPageState(this.book) : super(book);

  bool _isInLibrary;

  @override
  void initState() {
    super.initState();
    _isInLibrary = isInLibrary(this.book);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureProvider<FictionDetails>(
      create: (_) => getFictionDetails(this.book.book.url),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        _libraryStar(),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 0, 0),
                child: Column(
                  children: <Widget>[getImage(height: 250.0)],
                )),
            _titleAuthorBlock(theme: _theme, context: context),
          ],
        ),
        SizedBox(height: 6), // Padding
        _description(book, theme: _theme),
        ChapterList(),
      ]),
    );
  }

  Widget _libraryStar() {
    if (_isInLibrary) {
      return GestureDetector(
        onTap: () {
          removeFromLibrary(this.book);
          setState(() {
            _isInLibrary = false;
          });
          Fluttertoast.showToast(msg: "Removed from library");
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 12, 0),
          child: Icon(
            Icons.star,
            color: Colors.amber,
            size: itemIconSize,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          addToLibrary(this.book);
          setState(() {
            _isInLibrary = true;
          });
          Fluttertoast.showToast(msg: "Added to library");
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 12, 0),
          child: Icon(
            Icons.star_border,
            size: itemIconSize,
          ),
        ),
      );
    }
  }

  Widget _titleAuthorBlock({theme, context}) => Flexible(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.book.book.title,
                style: TextStyle(
                    color: theme.darkMode
                        ? darkModeTitleColor
                        : lightModeTitleColor,
                    fontSize: fontSizeNovelTitle),
                maxLines: 7,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 5),
            Consumer<FictionDetails>(
                builder: (context, value, child) =>
                    _authorText(value?.author, theme: theme))
          ],
        ),
      ));

  Widget _authorText(String authorName, {theme}) {
    if (authorName != null) {
      return Text("Author: " + authorName,
          style: TextStyle(
              color: theme.darkMode ? darkModeTitleColor : lightModeTitleColor,
              fontSize: fontSizeMain),
          maxLines: 7,
          overflow: TextOverflow.ellipsis);
    } else {
      return Text("Author: ",
          style: TextStyle(
              color: theme.darkMode ? darkModeTitleColor : lightModeTitleColor,
              fontSize: fontSizeMain),
          maxLines: 7,
          overflow: TextOverflow.ellipsis);
    }
  }

  Widget _description(book, {theme}) => Container(
      padding: const EdgeInsets.all(10),
      child: ExpandablePanel(
          header:
              Text('Description', style: TextStyle(fontSize: fontSizeMain + 1)),
          collapsed:
              _descriptionText(overflow: TextOverflow.ellipsis, maxLines: 7),
          expanded: _descriptionText(),
          theme: ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              iconColor:
                  theme.darkMode ? darkModeIconColor : lightModeIconColor)));

  Widget _descriptionText({TextOverflow overflow, int maxLines}) =>
      Consumer<FictionDetails>(builder: (context, value, child) {
        if (value != null)
          return Padding(
              padding: const EdgeInsets.only(top: 10),
              // Flutter_html does not allow max lines like Text/RichText does
              // implement some type of inconsistent version
              child: Html(
                onLinkTap: (url) => launch(url),
                data: maxLines != null
                    ? value.descriptionHtml.substring(
                            0,
                            (60 * maxLines) + 1 > value.descriptionHtml.length
                                ? value.descriptionHtml.length
                                : 60 * maxLines) +
                        (overflow == TextOverflow.ellipsis &&
                                (60 * maxLines) + 1 <
                                    value.descriptionHtml.length
                            ? "..."
                            : "")
                    : value.descriptionHtml,
                useRichText: true,
              ));
        return SizedBox.shrink();
      });
}
