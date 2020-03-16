import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/tabs/pages/chapter.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:royalroad_api/models.dart' show BookDetails;
import 'package:provider/provider.dart';

class ChapterList extends StatelessWidget {
  final Future<BookDetails> chapterFuture;

  ChapterList(this.chapterFuture);

  // TODO: Either refactor with pages or offer a reverse button
  // Note: Listview.builder does not support reordering
  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureBuilder<BookDetails>(
      future: chapterFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final chapterList = snapshot.data.chapterList;
          minLength() => chapterList.length < 8 ? chapterList.length - 1 : 8;
          final chapterListPreview = chapterList.sublist(0, minLength() + 1);

          // Bad way to do this - two listviews
          return Padding(
              padding: EdgeInsets.all(10),
              child: ExpandablePanel(
                  header: Text('Chapters', style: TextStyle(fontSize: 16)),
                  collapsed: _buildListView(chapterListPreview, chapterList),
                  expanded: _buildListView(chapterList),
                  iconColor:
                      _theme.darkMode ? Colors.white54 : Colors.black54));
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
                builder: (context) => _buildPageView(fullChapterList, index)));
          },
        ));
  }

  _buildPageView(fullChapterList, startChapterIndex) {
    var controller = PageController(initialPage: startChapterIndex);
    return PageView.builder(
      // key: PageStorageKey('chapterPage'),
      itemBuilder: (context, index) {
        return Chapter(fullChapterList[index]);
      },
      controller: controller,
      itemCount: fullChapterList.length,
    );
  }

  _buildListView(chapterList, [fullChapterList]) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: chapterList.length,
        itemBuilder: (context, index) {
          return _buildChapterEntry(
              chapterList,
              fullChapterList == null ? chapterList : fullChapterList,
              index,
              context);
        });
  }
}
