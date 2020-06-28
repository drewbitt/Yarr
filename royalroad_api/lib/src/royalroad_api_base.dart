import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:intl/intl.dart';
import 'package:royalroad_api/models.dart';
import 'package:royalroad_api/src/util.dart'
    show SearchInfo, absolute_url, clean_contents, tryAndDefault;

class Base {
  static const baseUrl = 'https://www.royalroad.com';
  static const baseCdnUrl = 'https://www.royalroadcdn.com';
  static const baseCdnUrl2 = 'https://cdn.royalroad.com';

  // RR doesn't sensor other scrapers but might as well be safe
  static const userAgent = 'Mozilla/5.0';
}

// TODO: Add logging, better future error messages

/// Returns list of books from the generic fiction-list-item pages on RR
List<FictionListResult> _getBookList(Document parsed) {
  var listResults = <FictionListResult>[];
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

    listResults.add(FictionListResult(
        Fiction(absolute_url(link.attributes['href']), link.text, imageUrl),
        info));
  }
  return listResults;
}

Future<List<FictionListResult>> searchFiction(String searchTerm) async {
  searchTerm = searchTerm.trim().replaceAll(' ', '+');
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

Future<FictionDetails> getFictionDetails(String book_url) async {
  final response =
      await http.get(book_url, headers: {'User-Agent': Base.userAgent});
  if (response.statusCode == 200) {
    final parsed = parse(response.body);
    var listChapters = <ChapterDetails>[];

    final entry = parsed.querySelector('tbody').querySelectorAll('tr');
    final numChapters =
        parsed.querySelector('tbody').querySelectorAll('a[href]').length;
    final author =
        parsed.querySelector('h3.mt-card-name').querySelector('a').text;

    for (var i in entry) {
      var chapter = i.querySelector('a[href]');

      final dFormat = DateFormat('EEEE, MMMM d, y H:m');
      final date = tryAndDefault(
          () => dFormat.parse(i.querySelector('time').attributes['title']),
          DateTime.now());
      final dateToString = i.querySelector('time').text;

      listChapters.add(ChapterDetails(chapter.text.trim(),
          absolute_url(chapter.attributes['href']), date, dateToString));
    }
    assert(listChapters.length == numChapters);

    return Future.value(FictionDetails(author, numChapters, listChapters));
  } else {
    return Future.error('Could not access Royalroad');
  }
}

// Needs a BookChapter object obtained from getFictionDetails(book_url)
Future<Chapter> getChapter(ChapterDetails chap) async {
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

    final id = int.parse(chap.url.split('/')[7]);
    final notes = _getChapterAuthorNotes(parsed);
    final beginNote = notes[0];
    final endNote = notes[1];

    final contents = parsed.querySelector('div.chapter-content');
    final cleaned_contents = clean_contents(contents);

    return Future.value(
        Chapter(id, chap, title, cleaned_contents, beginNote, endNote));
  } else {
    return Future.error('Could not access Royalroad');
  }
}

List<AuthorNote> _getChapterAuthorNotes(parsed) {
  AuthorNote beginNote;
  AuthorNote endNote;

  final notesTitle = parsed.querySelectorAll('span.caption-subject');
  final notesText = parsed.querySelectorAll('div.author-note');

  if (notesText.isNotEmpty) {
    if (notesText[0].parent.nextElementSibling.localName == 'hr') {
      endNote = AuthorNote(
          notesTitle[0].text,
          notesText[0]
              .querySelectorAll('p')
              .map((e) => e.text)
              .join('<br /><br />'));
    } else {
      beginNote = AuthorNote(
          notesTitle[0].text,
          notesText[0]
              .querySelectorAll('p')
              .map((e) => e.text)
              .join('<br /><br />'));
    }
  }
  // has both begin note and end note
  if (notesText.length > 1) {
    endNote = AuthorNote(
        notesTitle[1].text,
        notesText[1]
            .querySelectorAll('p')
            .map((e) => e.text)
            .join('<br /><br />'));
  }

  return [beginNote, endNote];
}

Future<List<FictionListResult>> getTrendingFictions() async {
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

Future<List<FictionListResult>> getWeeksPopularFictions() async {
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

Future<List<FictionListResult>> getBestRatedFictions() async {
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

bool _commentsHasNextPage(Document parsed) =>
    parsed.querySelector('li.page-active').nextElementSibling.hasContent();

int _commentsGetLastPageNum(Document parsed) {
  final first = parsed.querySelectorAll('li')?.last?.querySelector('a');

  if (first != null && first.attributes.containsKey('onclick')) {
    return int.parse(
        first.attributes['onclick']?.split(', ')[1]?.split(')')[0]);
  } else {
    return 1;
  }
}

/// Returns list of comments from a chapter id. Specify the page of comments
/// using page. Returns empty list of no comments.
// TODO: Track parent/children comments
Future<ChapterComments> getComments(int id, {int page = 1}) async {
  final url = Base.baseUrl + '/fiction/chapter/$id/comments/$page';
  final response = await http.get(url, headers: {'User-Agent': Base.userAgent});

  if (response.statusCode == 200) {
    final parsed = parse(response.body);

    var comments = <ChapterComment>[];
    parsed.querySelectorAll('div.media.media-v2').forEach((element) {
      final id = int.parse(element.querySelector('a').id.split('-')[1]);
      final postedDate = tryAndDefault(
          () => DateFormat('EEEE, MMMM d, y H:m')
              .parse(element.querySelector('time').attributes['title']),
          DateTime.now());
      final postedDateString = element.querySelector('time').text + 'ago';

      // clone so that doesn't effect comment author parsing
      var contentChildren =
          element.clone(true).querySelector('div.media-body').children;

      // Remove extra children in content
      contentChildren.removeAt(0); // remove h4
      final numContentElements = contentChildren.length;
      contentChildren.removeRange(
          numContentElements - 4, numContentElements); // remove extras at end
      // Remove empty tags (for empty p)
      //contentChildren.removeWhere((element) => element.text.isEmpty);
      // Throws unimplemented error for some reason. Alternative:
      contentChildren.forEach((element) {
        if (element.text.trim().isEmpty) {
          if (element.children.isEmpty) {
            element.remove();
          }
        }
      });

      final content =
          contentChildren.map((e) => e.innerHtml.trim()).join('<br><br>');

      final commentAuthor = CommentAuthor(
          int.parse(element
              .querySelector('span.name')
              .querySelector('a')
              .attributes['href']
              .split('/')[2]),
          element
              .querySelector('span.name')
              .querySelector('a')
              .text
              .split('@')[0],
          absolute_url(element.querySelector('img').attributes['src']));

      comments.add(ChapterComment(
          id, postedDate, postedDateString, content, commentAuthor));
    });

    final numPages = _commentsGetLastPageNum(parsed);
    return Future.value(ChapterComments(comments, numPages));
  } else {
    return Future.error('Could not access Royalroad');
  }
}
