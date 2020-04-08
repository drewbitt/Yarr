import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/ui/components/result_card.dart';
import 'package:flutterroad/ui/fiction/novel_details.dart';
import 'package:royalroad_api/models.dart' show FictionListResult;
import 'package:royalroad_api/royalroad_api.dart' show searchFiction;

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<FictionListResult>(
          searchBarPadding: const EdgeInsets.symmetric(horizontal: 10),
          headerPadding: const EdgeInsets.symmetric(horizontal: 10),
          listPadding: const EdgeInsets.symmetric(horizontal: 10),
          onSearch: searchFiction,
          placeHolder: Center(child: Text('Search for a novel')),
          cancellationWidget: Text("Cancel"),
          emptyWidget: Center(child: Text('No results')),
          debounceDuration: Duration(milliseconds: 800), // default is 500
          textStyle: TextStyle(), // fixes issue in dark mode
          onItemFound: (FictionListResult result, int index) {
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
