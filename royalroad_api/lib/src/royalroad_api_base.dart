import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:royalroad_api/src/models.dart' show BookSearchResult;
import 'package:royalroad_api/src/util.dart' show SearchInfo;

class Base {
  static const baseUrl = 'https://www.royalroad.com/';
}
// TODO: Add genres
// TODO: Consider using RR placeholder image
Future<List<BookSearchResult>> searchFiction(searchTerm) async {
  searchTerm = searchTerm.replaceAll(' ', '+');
  final url = Base.baseUrl + 'fictions/search?title=' + searchTerm;

  final response = await http.get(url);
  if (response.statusCode == 200) {
    var parsed = parse(response.body);
    var listResults = <BookSearchResult>[];
    
    for (var i in parsed.querySelectorAll('div.row.fiction-list-item')) {
      final link = i.querySelector('h2.fiction-title').querySelector('a');
      final info = SearchInfo.getSearchInfo(i.querySelector('div.row.stats'));
      final imageUrl = i.querySelector('img').attributes['src'];

      listResults.add(BookSearchResult(link.attributes['href'], link.text, imageUrl, info));
    }
    return Future.value(listResults);
  }
  return Future.error('Could not access Royalroad');
}
