import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/ui/chapter/chapter.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:royalroad_api/models.dart' show BookDetails, BookChapter;
import 'package:provider/provider.dart';

class ChapterList extends StatefulWidget {
  final Future<BookDetails> chapterFuture;

  ChapterList(this.chapterFuture);

  @override
  State<StatefulWidget> createState() => ChapterListState(this.chapterFuture);
}

class ChapterListState extends State<ChapterList> {
  final Future<BookDetails> chapterFuture;

  ChapterListState(this.chapterFuture);

  var _reverseList = false;

  void _onReverseTapped() {
    setState(() {
      _reverseList = !_reverseList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureBuilder<BookDetails>(
      future: chapterFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final chapterList = snapshot.data.chapterList;
          minLength() => chapterList.length < 9 ? chapterList.length - 1 : 8;
          final chapterListPreview = _reverseList
              ? chapterList.reversed
                  .toList()
                  .sublist(0, minLength() + 1)
                  .reversed
                  .toList()
              : chapterList.sublist(0, minLength() + 1);

          // Bad way to do this - two listviews
          return Padding(
              padding: EdgeInsets.all(10),
              child: ExpandablePanel(
                  header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Chapters', style: TextStyle(fontSize: 16)),
                        InkWell(
                            onTap: _onReverseTapped,
                            child: Icon(Icons.swap_vert,
                                color: _theme.darkMode
                                    ? Colors.white60
                                    : Colors.black.withAlpha(170)))
                      ]),
                  collapsed: _buildListView(chapterListPreview,
                      fullChapterList: chapterList, reverse: _reverseList),
                  expanded: _buildListView(chapterList, reverse: _reverseList),
                  theme: ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      iconColor:
                          _theme.darkMode ? Colors.white54 : Colors.black54)));
        } else {
          // NOTE: This spinner will never time out
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: CupertinoActivityIndicator()),
                  Text("Getting chapters", style: TextStyle(fontSize: 15)),
                ],
              ));
        }
      },
    );
  }

  _buildChapterEntry(chapterList, fullChapterList, index, context) {
    // fullChapterList used for swiping between pages past the preview pages
    final isPreview = chapterList.length != fullChapterList.length;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Text(chapterList[index].name,
                      overflow: TextOverflow.ellipsis)),
              Text(chapterList[index].releaseDateString + "ago")
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => _buildPageView(fullChapterList,
                    startChapterIndex: isPreview
                        ? _translateIndex(index, fullChapterList.length)
                        : index)));
          },
        ));
  }

  /// Method used for translating the index (used in onClick) when having a reverse preview list.
  // I don't like this either
  // TODO: Fix this whole reverse list mumbo jumbo
  _translateIndex(index, fullChapterListLength) {
    var rangeIndexList = Iterable<int>.generate(9).toList();
    final bumpVal = fullChapterListLength - 8;
    final indexOfIndex = rangeIndexList.indexOf(index);
    return rangeIndexList.map((e) => e + bumpVal).toList()[indexOfIndex];
  }

  _buildPageView(fullChapterList, {startChapterIndex}) {
    var controller = PageController(initialPage: startChapterIndex);
    return PageView.builder(
      itemBuilder: (context, index) {
        return Chapter(fullChapterList[index]);
      },
      controller: controller,
      itemCount: fullChapterList.length,
    );
  }

  _buildListView(List<BookChapter> chapterList,
      {bool reverse, List<BookChapter> fullChapterList}) {
    // fullChapterList = fullChapterList == null? chapterList: fullChapterList;
    return ListView.builder(
        shrinkWrap: true,
        reverse: reverse,
        physics: ClampingScrollPhysics(),
        itemCount: chapterList.length,
        itemBuilder: (context, index) {
          return _buildChapterEntry(
              chapterList,
              fullChapterList == null ? chapterList : fullChapterList,
              // fullChapterList == null? index: fullChapterList.length - (index+1),
              index,
              context);
        });
  }
}
