import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:royalroad_api/models.dart';
import 'package:royalroad_api/royalroad_api.dart';

import '../../../../util.dart';
import '../../../constants.dart';

class CommentPage extends StatefulWidget {
  final int id;

  CommentPage(this.id);

  @override
  State createState() => _CommentPageState(id);
}

class _CommentPageState extends State<CommentPage> {
  final int id;
  Future<ChapterComments> _futureChapterComments;

  _CommentPageState(this.id);

  int _currentPage;

  @override
  void initState() {
    super.initState();
    _futureChapterComments = getComments(id);
    _currentPage = 1;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureBuilder<ChapterComments>(
        future: _futureChapterComments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error getting comments");
            } else if (snapshot.hasData) {
              if (snapshot.data.comments.length == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BackButton(),
                    Expanded(
                        child: Center(
                      child: Text("No comments",
                          style: TextStyle(fontSize: fontSizeMain)),
                    )),
                  ],
                );
              } else {
                return SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BackButton(),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data.comments.length,
                          itemBuilder: (context, index) {
                            return _buildCommentBlock(
                                snapshot.data.comments[index],
                                context: context,
                                theme: _theme);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (snapshot.data.numPages != 1)
                          _buildPageNumbers(snapshot.data.numPages)
                      ]),
                );
              }
            } else {
              return _buildLoader();
            }
          } else {
            return _buildLoader();
          }
        });
  }

  _buildCommentBlock(ChapterComment comment,
          {@required context, @required theme}) =>
      Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Image column
                  Column(children: <Widget>[
                    _getImage(comment.commentAuthor.avatar,
                        height: imageSizeCommentAuthorAvatar)
                  ]),
                  Flexible(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          comment.commentAuthor.name,
                          style: TextStyle(
                              color: theme.darkMode
                                  ? darkModeTitleColor
                                  : lightModeTitleColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: Text(comment.content),
                      ),
                    ],
                  )),
                ]),
          ));

  // TODO: This was done in a non-mobile way. Change later
  _buildPageNumbers(int numPages) {
    var listWidgets = List<Widget>();
    if (_currentPage != 1) {
      listWidgets.add(_tappablePageNumber(_squarePageButton("«First"), 1));
      if (_currentPage > 2)
        listWidgets.add(
            _tappablePageNumber(_squarePageButton("«Prev"), _currentPage - 1));
    }

    int beginRange;
    int maxCutOffPage;
    if (_currentPage >= 4) {
      beginRange = _currentPage - 3;
      maxCutOffPage = _currentPage + 2;
    } else {
      maxCutOffPage = 5;
      beginRange = 0;
    }

    [for (var i = beginRange; i < numPages; i += 1) i].forEach((number) {
      if (number < maxCutOffPage) if (number + 1 == _currentPage)
        listWidgets.add(_tappablePageNumber(
            _squarePageButton(number + 1, currentPage: true), number + 1));
      else
        listWidgets.add(
            _tappablePageNumber(_squarePageButton(number + 1), number + 1));
    });
    if (_currentPage != numPages) {
      listWidgets.add(
          _tappablePageNumber(_squarePageButton("Next»"), _currentPage + 1));
      listWidgets
          .add(_tappablePageNumber(_squarePageButton("Last»"), numPages));
    }

    listWidgets = listWidgets
        .map((e) => Padding(
              padding: const EdgeInsets.only(right: 3),
              child: e,
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: listWidgets,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  _squarePageButton(item, {currentPage = false}) => Container(
        decoration: BoxDecoration(
          border: Border.all(),
          color: currentPage ? Colors.blue : null,
        ),
        padding: const EdgeInsets.all(7.0),
        child: Text(item.toString()),
      );

  _tappablePageNumber(Widget child, int pageNum) => InkWell(
        child: child,
        onTap: () => setState(() {
          _futureChapterComments = getComments(id, page: pageNum);
          _currentPage = pageNum;
        }),
      );

  _buildLoader() => Center(
          child: CupertinoActivityIndicator(
        radius: centerLoadingSpinnerRadius,
      ));

  _getImage(url, {@required height}) => getImageUtil(url, height: height);
}
