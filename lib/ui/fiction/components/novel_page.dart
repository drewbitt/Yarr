import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/base/StatelessBookBase.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:flutterroad/ui/fiction/components/chapter_list.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:royalroad_api/models.dart'
    show FictionListResult, FictionDetails;
import 'package:royalroad_api/royalroad_api.dart' show getFictionDetails;

class NovelPage extends StatelessBookBase {
  final FictionListResult book;

  NovelPage(this.book) : super(book);

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureProvider<FictionDetails>(
      create: (_) => getFictionDetails(this.book.book.url),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                    child: Column(
                      children: <Widget>[getImage(height: 250.0)],
                    )),
                _buildTitleAuthor(theme: _theme, context: context)
              ],
            ),
            SizedBox(height: 6), // Padding
            _buildDescription(book, theme: _theme),
            ChapterList(),
          ]),
    );
  }

  _buildTitleAuthor({theme, context}) => Flexible(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 6),
        child: Column(
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
            Consumer<FictionDetails>(builder: (context, value, child) {
              if (value != null)
                return Text("Author: " + value.author,
                    style: TextStyle(
                        color: theme.darkMode
                            ? darkModeTitleColor
                            : lightModeTitleColor,
                        fontSize: fontSizeMain),
                    maxLines: 7,
                    overflow: TextOverflow.ellipsis);
              return SizedBox.shrink();
            })
          ],
        ),
      ));

  _buildDescription(book, {theme}) => Container(
      padding: const EdgeInsets.all(10),
      child: ExpandablePanel(
          header:
              Text('Description', style: TextStyle(fontSize: fontSizeMain + 1)),
          collapsed: _buildDescriptionText(book.info.description,
              overflow: TextOverflow.ellipsis, maxLines: 7),
          expanded: _buildDescriptionText(book.info.description),
          theme: ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              iconColor:
                  theme.darkMode ? darkModeIconColor : lightModeIconColor)));

  _buildDescriptionText(text, {TextOverflow overflow, int maxLines}) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child:
          Text(text, softWrap: true, maxLines: maxLines, overflow: overflow));
}
