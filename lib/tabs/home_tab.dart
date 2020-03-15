import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/tabs/components/ResultCard.dart';
import 'package:flutterroad/tabs/pages/novel_details.dart';
import 'package:royalroad_api/models.dart' show BookListResult;
import 'package:royalroad_api/royalroad_api.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child:
                  Text("Trending Fictions: ", style: TextStyle(fontSize: 20))),
          _trendingList(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child:
                  Text("Popular this week: ", style: TextStyle(fontSize: 20))),
          _popularList()
        ],
      ),
    );
  }
}

_buildPageView(List<BookListResult> fictions) {
  return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: fictions.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: EdgeInsets.all(10), // not sure about value rn
            child: InkWell(
                child: ResultCard(fictions[index], showBorder: false),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NovelDetails(fictions[index])));
                }));
      });
}

_trendingList() => _buildList(getTrendingFictions());

_popularList() => _buildList(getWeeksPopularFictions());

_buildList(func) => Container(
    height: 160,
    child: FutureBuilder<List<BookListResult>>(
      future: func,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data;
          return _buildPageView(data);
        } else {
          return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: MediaQuery.of(context).size.width / 40),
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
    ));
