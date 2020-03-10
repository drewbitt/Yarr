import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:royalroad_api/src/models.dart'
    show BookSearchResult, BookDetails, BookChapter, BookChapterContents;
import 'package:royalroad_api/src/util.dart'
    show SearchInfo, absolute_url, clean_contents;

class Base {
  static const baseUrl = 'https://www.royalroad.com';
  static const baseCdnUrl = 'https://www.royalroadcdn.com';

  // RR doesn't sensor other scrapers but might as well be safe
  static const userAgent = 'Mozilla/5.0';
}

// TODO: Add genres
Future<List<BookSearchResult>> searchFiction(searchTerm) async {
  searchTerm = searchTerm.replaceAll(' ', '+');
  // Can also search for keyword instead of title?
  final url = Base.baseUrl + '/fictions/search?title=' + searchTerm;

  final response = await http.get(url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    final parsed = parse(response.body);
    var listResults = <BookSearchResult>[];

    for (var i in parsed.querySelectorAll('div.row.fiction-list-item')) {
      final link = i.querySelector('h2.fiction-title').querySelector('a');
      final imageUrl = absolute_url(i.querySelector('img').attributes['src']);

      var info = SearchInfo.getSearchInfo(i.querySelector('div.row.stats'));

      // Genres not in same div as other info, add to object
      var genres = <String>[];
      i.querySelectorAll('span[class^=label]').forEach((element) { genres.add(element.text);});
      info.genres = genres;

      listResults.add(BookSearchResult(
          absolute_url(link.attributes['href']), link.text, imageUrl, info));
    }
    return Future.value(listResults);
  }
  return Future.error('Could not access Royalroad');
}

Future<BookDetails> getBookDetails(book_url) async {
  final response =
      await http.get(book_url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    final parsed = parse(response.body);
    var listChapters = <BookChapter>[];

    final entry = parsed.querySelector('tbody').querySelectorAll('tr');
    final numChapters =
        parsed.querySelector('tbody').querySelectorAll('a[href]').length;
    final author =
        parsed.querySelector('h3.mt-card-name').querySelector('a').text;

    for (var i in entry) {
      var chapter = i.querySelector('a[href]');

      final dFormat = DateFormat('EEEE, d MMMM y H:m');
      var date = dFormat.parse(i.querySelector('time').attributes['title']);

      listChapters.add(BookChapter(
          chapter.text.trim(), absolute_url(chapter.attributes['href']), date));
    }
    assert(listChapters.length == numChapters);

    return Future.value(BookDetails(author, numChapters, listChapters));
  } else {
    return Future.error('Could not access Royalroad');
  }
}

// Needs a BookChapter object obtained from getBookDetails(book_url)
//TODO: Write test
Future<BookChapterContents> getChapter(BookChapter chap) async {
  final response =
      await http.get(chap.url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    var parsed = parse(response.body);
    var title;
    // Might as well grab the title inside the chapter in case different
    if (parsed.querySelector('h2').hasContent()) {
      title = parsed.querySelector('h2').text;
    } else {
      title = chap.name;
    }

    var contents = parsed.querySelector('div.chapter-content');
    var cleaned_contents = clean_contents(contents);

    return Future.value(BookChapterContents(chap, title, cleaned_contents));
  } else {
    return Future.error('Could not access Royalroad');
  }
}
