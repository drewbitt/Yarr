import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Element;

class SearchInfo {
  static getSearchInfo(parsed) {
    // print(parsed.outerHtml);
    print(getDescription(parsed));
    print(getFollowers(parsed));
    print(getPages(parsed));
    print(getRating(parsed));
    print(getViews(parsed));
    print(getChapters(parsed));
    print(getLastUpdate(parsed));
  }

  static getFollowers(Element parsed) =>
      int.parse(parsed.querySelector('i.fa.fa-users').nextElementSibling.text.split(' Followers')[0]);
  static getPages(Element parsed) =>
      int.parse(parsed.querySelector('i.fa.fa-book').nextElementSibling.text.split(' Pages')[0]);
  static getRating(Element parsed) =>
      double.parse(parsed.querySelector('i.fa.fa-star').nextElementSibling.attributes['title']);
  static getViews(Element parsed) =>
      int.parse(parsed.querySelector('i.fa.fa-eye').nextElementSibling.text.split(' Views')[0].replaceAll(',',''));
  static getChapters(Element parsed) =>
      int.parse(parsed.querySelector('i.fa.fa-list').nextElementSibling.text.split(' Chapters')[0]);
  static getLastUpdate(Element parsed) =>
      DateTime.parse(parsed.querySelector('i.fa.fa-calendar').nextElementSibling.querySelector('time').attributes['datetime']);
  static getDescription(Element parsed) {
    var descriptionList = new List();
    parsed.querySelector('div[id^=description]').children.forEach((element) => descriptionList.add(element.text));
    var descriptionConcat = '';
    descriptionList.forEach((element) => descriptionConcat = descriptionConcat + element + ' ');
    return descriptionConcat.trim();
  }
}