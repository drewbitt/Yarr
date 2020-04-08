import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/ui/components/big_result_card.dart';
import 'package:flutterroad/ui/components/result_card.dart';
import 'package:flutterroad/ui/constants.dart';
import 'package:flutterroad/ui/fiction/novel_details.dart';
import 'package:no_scroll_glow/no_scroll_glow.dart';
import 'package:page_view_indicators/arrow_page_indicator.dart';
import 'package:royalroad_api/models.dart' show FictionListResult;
import 'package:royalroad_api/royalroad_api.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NoScrollGlow(
            child: ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(top: 10), child: _bigFictionList()),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 13, 10, 0),
                child: Text("Trending Fictions: ",
                    style: TextStyle(fontSize: fontSizeHomeHeader))),
            _trendingList(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text("Popular this week: ",
                    style: TextStyle(fontSize: fontSizeHomeHeader))),
            _popularList()
          ],
        ),
      ],
    )));
  }

  _buildPageView(List<FictionListResult> fictions,
          PageController pageController, ValueNotifier currentPageNotifier,
          {big = false}) =>
      PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: fictions.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.all(10), // not sure about value rn
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
        // have to give height in a horizontal scrolling list
        height: big ? 320 : 165,
        child: FutureBuilder<List<FictionListResult>>(
          future: func,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                    child: Text("Error getting fictions",
                        style: TextStyle(fontSize: fontSizeMain)));
              } else if (snapshot.hasData) {
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
                return _buildLoader();
              }
            } else {
              return _buildLoader();
            }
          },
        ));
  }

  _buildLoader() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CupertinoActivityIndicator()),
          Text("Getting fictions", style: TextStyle(fontSize: fontSizeMain)),
        ],
      ));
}
