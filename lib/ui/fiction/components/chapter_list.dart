import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/ui/chapter/chapter.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:flutterroad/data/viewmodels/fiction_view_model.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:royalroad_api/models.dart' show FictionDetails, ChapterDetails;
import 'package:provider/provider.dart';

class ChapterList extends StatefulWidget {
  final Future<FictionDetails> chapterFuture;

  ChapterList(this.chapterFuture);

  @override
  State<StatefulWidget> createState() => _ChapterListState(this.chapterFuture);
}

class _ChapterListState extends State<ChapterList> {
  final Future<FictionDetails> chapterFuture;

  _ChapterListState(this.chapterFuture);

  var _reverseList = false;
  PageController _pageController;

  @override
  void dispose() {
    super.dispose();
    _pageController?.dispose();
  }

  void _onReverseTapped() {
    setState(() {
      _reverseList = !_reverseList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureBuilder<FictionDetails>(
      future: chapterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Error getting chapters",
                style: TextStyle(fontSize: fontSizeMain));
          } else if (snapshot.hasData) {
            final List<ChapterDetails> chapterList = snapshot.data.chapterList;
            final List<ChapterDetails> chapterListPreview =
                getChapterListPreview(chapterList, _reverseList);

            // Bad way to do this - two listviews
            return Padding(
                padding: const EdgeInsets.all(10),
                child: ExpandablePanel(
                  header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Chapters',
                            style: TextStyle(fontSize: fontSizeMain + 1)),
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
                      iconColor: _theme.darkMode
                          ? darkModeIconColor
                          : lightModeIconColor,
                      tapHeaderToExpand: false),
                ));
          } else {
            return _buildLoader();
          }
        } else {
          return _buildLoader();
        }
      },
    );
  }

  _buildLoader() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
      child: Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CupertinoActivityIndicator()),
          Text("Getting chapters", style: TextStyle(fontSize: fontSizeMain)),
        ],
      ));

  _buildChapterEntry(List<ChapterDetails> chapterList,
      {List<ChapterDetails> fullChapterList,
      int index,
      context,
      bool reverse}) {
    // fullChapterList used for swiping between pages past the preview pages
    final isPreview = chapterList.length != fullChapterList.length && reverse;
    return InkWell(
        key: Key('chapterList_item_$index'),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Text(chapterList[index].name,
                        overflow: TextOverflow.ellipsis)),
                Text(chapterList[index].releaseDateString + "ago")
              ],
            )),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => _buildPageView(fullChapterList,
                  startChapterIndex: isPreview
                      ? translateListIndex(index, fullChapterList.length)
                      : index)));
        });
  }

  _buildPageView(List<ChapterDetails> fullChapterList,
      {int startChapterIndex}) {
    _pageController = PageController(initialPage: startChapterIndex);
    return PageView.builder(
      itemBuilder: (context, index) {
        return Chapter(fullChapterList[index]);
      },
      controller: _pageController,
      itemCount: fullChapterList.length,
    );
  }

  _buildListView(List<ChapterDetails> chapterList,
      {bool reverse, List<ChapterDetails> fullChapterList}) {
    return ListView.builder(
        shrinkWrap: true,
        reverse: reverse,
        physics: ClampingScrollPhysics(),
        key: Key("chapterList"),
        itemCount: chapterList.length,
        itemBuilder: (context, index) {
          return _buildChapterEntry(chapterList,
              fullChapterList: fullChapterList ?? chapterList,
              index: index,
              context: context,
              reverse: reverse);
        });
  }
}
