import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image column
          Column(
            children: <Widget>[
              _getImage(MediaQuery.of(context).size.height / 6),
            ],
          ),
          // TODO: Look into this strat of dividing - feasible?
          SizedBox(width: MediaQuery.of(context).size.width / 50), // Padding
          // Details column 1
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 150),
              Text(this.title,
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: MediaQuery.of(context).size.height / 43),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              SizedBox(
                  height: MediaQuery.of(context).size.height / 45), // Padding
              Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // TODO: Use IconTheme if not doing multiple sizes later
                      Row(children: <Widget>[
                        Icon(Icons.people, size: 22),
                        InkWell(
                            child: Text(
                                this.info.followers.toString() + " Followers"))
                      ]),
                      Row(children: <Widget>[
                        Icon(Icons.book, size: 22),
                        InkWell(
                            child: Text(this.info.pages.toString() + " Pages"))
                      ]),
                      Row(children: <Widget>[
                        Icon(Icons.list, size: 22),
                        InkWell(
                            child: Text(
                                this.info.chapters.toString() + " Chapters"))
                      ])
                    ],
                  ),
                  SizedBox(
                      width:
                          MediaQuery.of(context).size.height / 25), // Padding
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Icon(Icons.star, size: 22),
                        InkWell(
                            child: Text(this.info.rating.toString() + " Stars"))
                      ]),
                      Row(children: <Widget>[
                        Icon(Icons.visibility, size: 22),
                        InkWell(
                            child: Text(NumberFormat.compact()
                                    .format(this.info.views)
                                    .toString() +
                                " Views"))
                      ]),
                      Row(children: <Widget>[
                        Icon(Icons.calendar_today, size: 22),
                        InkWell(
                            child: Text(DateFormat('MMM, d y')
                                .format(this.info.lastUpdate)
                                .toString()))
                      ]),
                    ],
                  )
                ],
              )
            ],
          ))
        ],
      ),
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
    );
  }

  // Truly not async?
  Image _getImage(height) => Image.network(this.imageUrl, height: height);
}
