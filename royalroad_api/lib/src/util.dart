import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Element, Node, Text;
import 'package:html/dom_parsing.dart' show isVoidElement;
import 'package:royalroad_api/src/models.dart' show BookSearchInfo;
import 'package:royalroad_api/src/royalroad_api_base.dart' show Base;

class SearchInfo {
  static BookSearchInfo getSearchInfo(parsed) {
    return BookSearchInfo(
        getFollowers(parsed),
        getPages(parsed),
        getChapters(parsed),
        getViews(parsed),
        getRating(parsed),
        getLastUpdate(parsed),
        getDescription(parsed));
  }

  static int getFollowers(Element parsed) => int.parse(parsed
      .querySelector('i.fa.fa-users')
      .nextElementSibling
      .text
      .split(' Followers')[0]
      .replaceAll(',', ''));

  static int getPages(Element parsed) => int.parse(parsed
      .querySelector('i.fa.fa-book')
      .nextElementSibling
      .text
      .split(' Pages')[0]
      .replaceAll(',', ''));

  static double getRating(Element parsed) => double.parse(parsed
      .querySelector('i.fa.fa-star')
      .nextElementSibling
      .attributes['title']);

  static int getViews(Element parsed) => int.parse(parsed
      .querySelector('i.fa.fa-eye')
      .nextElementSibling
      .text
      .split(' Views')[0]
      .replaceAll(',', ''));

  static int getChapters(Element parsed) => int.parse(parsed
      .querySelector('i.fa.fa-list')
      .nextElementSibling
      .text
      .split(' Chapters')[0]);

  static DateTime getLastUpdate(Element parsed) => DateTime.parse(parsed
      .querySelector('i.fa.fa-calendar')
      .nextElementSibling
      .querySelector('time')
      .attributes['datetime']);

  static String getDescription(Element parsed) {
    var descriptionList = [];
    parsed
        .querySelector('div[id^=description]')
        .children
        .forEach((element) => descriptionList.add(element.text));
    var descriptionConcat = '';
    descriptionList.forEach(
        (element) => descriptionConcat = descriptionConcat + element + '\n\n');
    return descriptionConcat.trim();
  }
}

String absolute_url(String url) {
  if (url.contains(Base.baseUrl) || url.contains(Base.baseCdnUrl)) {
    return url;
  } else if (url[0] == '/') {
    // Only images of existing book covers use baseCdnUrl it seems
    return Base.baseUrl + url;
  } else {
    throw 'URL is messed up';
  }
}

String clean_contents(Element div) {
  var toRemove = [];

  for (var tag in div.nodes) {
    if (tag.nodeType == Node.COMMENT_NODE) {
      toRemove.add(tag); // Remove comments
    }
  }

  // Remove like this since can't remove in-place
  div.nodes.removeWhere((e) => toRemove.contains(e));

  return div.outerHtml;
}
