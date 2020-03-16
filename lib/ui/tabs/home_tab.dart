import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/ui/components/BigResultCard.dart';
import 'package:flutterroad/ui/components/ResultCard.dart';
import 'package:flutterroad/ui/fiction/novel_details.dart';
import 'package:page_view_indicators/arrow_page_indicator.dart';
import 'package:royalroad_api/models.dart' show BookListResult;
import 'package:royalroad_api/royalroad_api.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10), child: _bigFictionList()),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text("Trending Fictions: ",
                    style: TextStyle(fontSize: 20))),
            _trendingList(),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Popular this week: ",
                    style: TextStyle(fontSize: 20))),
            _popularList()
          ],
        ),
      ],
    ));
  }

  _buildPageView(List<BookListResult> fictions, PageController pageController,
          ValueNotifier currentPageNotifier,
          {big = false}) =>
      PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: fictions.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Padding(
                padding: EdgeInsets.all(10), // not sure about value rn
                child: InkWell(
                    child: big
                        ? BigResultCard(fictions[index], index: index)
                        : ResultCard(fictions[index], showBorder: false),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NovelDetails(fictions[index])));
                    }));
          },
          onPageChanged: (int index) {
            currentPageNotifier.value = index;
          });

  _bigFictionList() => _buildList(getBestRatedFictions(), big: true);

  _trendingList() => _buildList(getTrendingFictions());

  _popularList() => _buildList(getWeeksPopularFictions());

  _buildList(func, {big = false}) {
    final _pageController = PageController();
    final _currentPageNotifier = ValueNotifier<int>(0);

    return Container(
        height: big ? 310 : 160,
        child: FutureBuilder<List<BookListResult>>(
          future: func,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return ArrowPageIndicator(
                  isInside: true,
                  pageController: _pageController,
                  currentPageNotifier: _currentPageNotifier,
                  // not a fan that on black covers, the left icon disappears. Living with it right now
                  itemCount: data.length,
                  child: _buildPageView(
                      data, _pageController, _currentPageNotifier,
                      big: big));
            } else {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: CupertinoActivityIndicator()),
                      Text("Getting fictions", style: TextStyle(fontSize: 15)),
                    ],
                  ));
            }
          },
        ));
  }
}
