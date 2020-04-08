import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persist_theme/data/models/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:royalroad_api/models.dart';
import 'package:royalroad_api/royalroad_api.dart';

import '../../../../util.dart';
import '../../../constants.dart';

class CommentPage extends StatelessWidget {
  final int id;

  CommentPage(this.id);

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeModel>(context);
    return FutureBuilder<List<ChapterComment>>(
        future: getComments(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error getting comments");
            } else if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BackButton(),
                    Expanded(
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return _buildCommentBlock(snapshot.data[index],
                              context: context, theme: _theme);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
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
                      )
                    ],
                  ))
                ]),
          ));

  _buildLoader() => Center(
          child: CupertinoActivityIndicator(
        radius: 15,
      ));

  _getImage(url, {@required height}) => getImageUtil(url, height: height);
}
