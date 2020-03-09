import 'package:flutter/material.dart';
import 'package:royalroad_api/src/models.dart' show BookSearchInfo;

class ResultCard extends StatelessWidget {
  // Exact same data as BookSearchResult
  final String url, title;
  final String imageUrl;
  final BookSearchInfo info;

  ResultCard(this.url, this.title, this.imageUrl, this.info);

//  var _image;
//
//  @override
//  void initState() {
//    _image = _getImage();
//  }

  @override
  Widget build(BuildContext context) {
//    return Card(
//        child: ListTile(
//            title: Text(this.title),
//            // subtitle: Text(result.title),
//            onTap: () {
//              Navigator.of(context).push(
//                  MaterialPageRoute(builder: (context) => Detail()));
//            }));
//  },
    // This gon get wild
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Image column
        Column(
          children: <Widget>[
            _getImage(MediaQuery.of(context).size.height / 7),
          ],
        ),
        SizedBox(width: MediaQuery.of(context).size.height / 80), // Padding
        // Details column 1
        Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.title,
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: MediaQuery.of(context).size.height / 43),
                maxLines: 3),
            SizedBox(
                height: MediaQuery.of(context).size.height / 45), // Padding
            Text(this.info.followers.toString() + " Followers"),
            Text(this.info.pages.toString() + " Pages"),
            Text(this.info.chapters.toString() + " Chapters")
          ],
        ))
      ],
    );
  }

  // Truly not async?
  Image _getImage(height) => Image.network(this.imageUrl, height: height);
}
