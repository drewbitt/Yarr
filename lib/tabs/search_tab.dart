import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/tabs/components/ResultCard.dart';
import 'package:flutterroad/tabs/pages/novel_details.dart';
import 'package:royalroad_api/models.dart' show BookListResult;
import 'package:royalroad_api/royalroad_api.dart' show searchFiction;

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final SearchBarController<BookListResult> _searchBarController =
      SearchBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<BookListResult>(
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          listPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: searchFiction,
          searchBarController: _searchBarController,
          placeHolder: Center(child: Text('Search for a novel')),
          cancellationWidget: Text("Cancel"),
          emptyWidget: Center(child: Text('No results')),
          // mainAxisSpacing: 10,
          // crossAxisSpacing: 10,
          debounceDuration: Duration(milliseconds: 800), // default is 500
          onItemFound: (BookListResult result, int index) {
            return InkWell(
                child: ResultCard(result),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NovelDetails(result)));
                });
          },
        ),
      ),
    );
  }
}
