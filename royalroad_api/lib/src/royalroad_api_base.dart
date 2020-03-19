import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:royalroad_api/models.dart'
    show
        AuthorNote,
        BookListResult,
        BookDetails,
        BookChapter,
        BookChapterContents,
        Book;
import 'package:royalroad_api/src/util.dart'
    show SearchInfo, absolute_url, clean_contents;

class Base {
  static const baseUrl = 'https://www.royalroad.com';
  static const baseCdnUrl = 'https://www.royalroadcdn.com';

  // RR doesn't sensor other scrapers but might as well be safe
  static const userAgent = 'Mozilla/5.0';
}

/// Returns list of books from the generic fiction-list-item pages on RR
List<BookListResult> _getBookList(Document parsed) {
  var listResults = <BookListResult>[];
  for (var i in parsed.querySelectorAll('div.row.fiction-list-item')) {
    final link = i.querySelector('h2.fiction-title').querySelector('a');
    final imageUrl = absolute_url(i.querySelector('img').attributes['src']);

    var info = SearchInfo.getSearchInfo(i.querySelector('div.row.stats'));

    // Genres not in same div as other info, add to object
    var genres = <String>[];
    i.querySelectorAll('span[class^=label]').forEach((element) {
      genres.add(element.text);
    });
    info.genres = genres;

    listResults.add(BookListResult(
        Book(absolute_url(link.attributes['href']), link.text, imageUrl),
        info));
  }
  return listResults;
}

Future<List<BookListResult>> searchFiction(searchTerm) async {
  searchTerm = searchTerm.replaceAll(' ', '+');
  // Can also search for keyword instead of title?
  final url = Base.baseUrl + '/fictions/search?title=' + searchTerm;

  final response = await http.get(url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    final parsed = parse(response.body);

    final listResults = _getBookList(parsed);
    return Future.value(listResults);
  }
  return Future.error('Could not access Royalroad');
}

Future<BookDetails> getFictionDetails(book_url) async {
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
      final date = dFormat.parse(i.querySelector('time').attributes['title']);
      final dateToString = i.querySelector('time').text;

      listChapters.add(BookChapter(chapter.text.trim(),
          absolute_url(chapter.attributes['href']), date, dateToString));
    }
    assert(listChapters.length == numChapters);

    return Future.value(BookDetails(author, numChapters, listChapters));
  } else {
    return Future.error('Could not access Royalroad');
  }
}

// Needs a BookChapter object obtained from getFictionDetails(book_url)
Future<BookChapterContents> getChapter(BookChapter chap) async {
  final response =
      await http.get(chap.url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    final parsed = parse(response.body);
    String title;
    // Might as well grab the title inside the chapter in case different
    if (parsed.querySelector('h2').hasContent()) {
      title = parsed.querySelector('h1').text;
    } else {
      title = chap.name;
    }

    final contents = parsed.querySelector('div.chapter-content');
    final cleaned_contents = clean_contents(contents);

    AuthorNote note;
    // Get note if present
    // note is before comments (also a caption-subject) so OK to do
    try {
      note = AuthorNote(
          parsed.querySelector('span.caption-subject').text,
          parsed
              .querySelector('div.portlet-body.author-note')
              .querySelectorAll('p')
              .map((e) => e.text)
              .join('<br /><br />'));
    } catch (_) {}
    ;

    return Future.value(
        BookChapterContents(chap, title, cleaned_contents, note));
  } else {
    return Future.error('Could not access Royalroad');
  }
}

Future<List<BookListResult>> getTrendingFictions() async {
  final url = Base.baseUrl + '/fictions/trending';
  final response = await http.get(url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    final parsed = parse(response.body);
    final listResult = _getBookList(parsed);

    return Future.value(listResult);
  } else {
    return Future.error('Could not access Royalroad');
  }
}

Future<List<BookListResult>> getWeeksPopularFictions() async {
  final url = Base.baseUrl + '/fictions/weekly-popular';
  final response = await http.get(url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    final parsed = parse(response.body);
    final listResult = _getBookList(parsed);

    return Future.value(listResult);
  } else {
    return Future.error('Could not access Royalroad');
  }
}

Future<List<BookListResult>> getBestRatedFictions() async {
  final url = Base.baseUrl + '/fictions/best-rated';
  final response = await http.get(url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    final parsed = parse(response.body);
    final listResult = _getBookList(parsed);

    return Future.value(listResult);
  } else {
    return Future.error('Could not access Royalroad');
  }
}
