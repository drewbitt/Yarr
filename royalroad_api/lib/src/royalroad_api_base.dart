import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:royalroad_api/src/models.dart' show BookSearchResult, BookDetails, BookChapter;
import 'package:royalroad_api/src/util.dart' show SearchInfo, absolute_url;

class Base {
  static const baseUrl = 'https://www.royalroad.com';
  // RR doesn't sensor other scrapers but might as well be safe
  static const userAgent = 'Mozilla/5.0';
}

// TODO: Add genres
// TODO: Consider using RR placeholder image
Future<List<BookSearchResult>> searchFiction(searchTerm) async {
  searchTerm = searchTerm.replaceAll(' ', '+');
  // Can also search for keyword instead of title?
  final url = Base.baseUrl + '/fictions/search?title=' + searchTerm;

  final response = await http.get(url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    var parsed = parse(response.body);
    var listResults = <BookSearchResult>[];
    
    for (var i in parsed.querySelectorAll('div.row.fiction-list-item')) {
      final link = i.querySelector('h2.fiction-title').querySelector('a');
      final info = SearchInfo.getSearchInfo(i.querySelector('div.row.stats'));
      final imageUrl = i.querySelector('img').attributes['src'];

      listResults.add(BookSearchResult(absolute_url(link.attributes['href']), link.text, imageUrl, info));
    }
    return Future.value(listResults);
  }
  return Future.error('Could not access Royalroad');
}

Future<BookDetails> getBookDetails(url) async {
  final response = await http.get(url, headers: {'User-Agent': Base.userAgent});
  if(response.statusCode == 200) {
    var parsed = parse(response.body);
    var listChapters = <BookChapter>[];

    final entry = parsed.querySelector('tbody').querySelectorAll('tr');
    final numChapters = parsed.querySelector('tbody').querySelectorAll('a[href]').length;
    final author = parsed.querySelector('h3.mt-card-name').querySelector('a').text;

    for (var i in entry) {
      var chapter = i.querySelector('a[href]');

      final dFormat = DateFormat('EEEE, d MMMM y H:m');
      var date = dFormat.parse(i.querySelector('time').attributes['title']);

      listChapters.add(BookChapter(chapter.text.trim(), absolute_url(chapter.attributes['href']), date));
    }
    assert(listChapters.length == numChapters);

    return Future.value(BookDetails(author, numChapters, listChapters));
  }
  else {
    return Future.error('Could not access Royalroad');
  }
}