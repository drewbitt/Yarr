import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:flutterroad/util.dart';
import 'package:royalroad_api/models.dart';
import 'package:royalroad_api/royalroad_api.dart';

class ChapterComments extends StatefulWidget {
  final int id;

  ChapterComments(this.id);

  @override
  State createState() => _ChapterCommentsState(id);
}

class _ChapterCommentsState extends State<ChapterComments> {
  final int id;
  Future<List<ChapterComment>> _futureChapterComments;

  _ChapterCommentsState(this.id);

  @override
  void initState() {
    super.initState();
    _futureChapterComments = getComments(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ChapterComment>>(
        future: _futureChapterComments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error getting comments");
            } else if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _buildCommentBlock(snapshot.data[index]);
                },
              );
            } else {
              return _buildLoader();
            }
          } else {
            return _buildLoader();
          }
        });
  }

  _buildCommentBlock(ChapterComment comment) => Container(
      width: MediaQuery.of(context).size.width,
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        // Image column
        Column(children: <Widget>[
          getImage(comment.commentAuthor.avatar, height: imageSizeCommentAuthorAvatar)
        ],)
      ]));

  _buildLoader() => CupertinoActivityIndicator();

  getImage(url, {@required height}) => getImageUtil(url, height: height);
}
