import 'package:html/dom.dart' show Element, Node;
// import 'package:html/dom_parsing.dart' show isVoidElement;
import 'package:royalroad_api/models.dart' show FictionListInfo;
import 'package:royalroad_api/src/royalroad_api_base.dart' show Base;

class SearchInfo {
  static FictionListInfo getSearchInfo(parsed) {
    return FictionListInfo(
        [], // empty for now since not found in 'row stats', add elsewhere
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
      .split(' Chapters')[0]
      .replaceAll(',', ''));

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
  if (url.contains(Base.baseUrl) || url.contains(Base.baseCdnUrl) || url.contains(Base.baseCdnUrl2)) {
    return url;
  } else if (url[0] == '/') {
    // Only images of existing book covers use baseCdnUrl it seems
    return Base.baseUrl + url;
  } else {
    throw 'URL is messed up';
  }
}

String clean_contents(Element div) {
  var strElements = StringBuffer();

  for (var tag in div.nodes) {
    // Remove comments. Not sure if necessary in RR actually.
    if (tag.nodeType != Node.COMMENT_NODE) {
      // An attempt to remove the outer div tag by concatenating children
      try {
        final ele = tag as Element;
        strElements.write(ele.outerHtml);
      } catch (_) {}
      ;
    }
  }

  // Remove the div reference
  return strElements.toString();
}

dynamic tryAndDefault(dynamic Function() ele, dynamic defaultValue) {
  try {
    return ele();
  }
  catch (err){
    print(err);
    return defaultValue;
  }
}
