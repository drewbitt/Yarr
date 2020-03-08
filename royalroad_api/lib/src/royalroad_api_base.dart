// TODO: Put public facing types in this file.
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:royalroad_api/src/models.dart' show BookSearchResult;
import 'package:royalroad_api/src/util.dart' show SearchInfo;

const x = 'Test';
class Base {
  static const base_url = 'https://www.royalroad.com/';
}

search_fiction(searchTerm) async {
  searchTerm = searchTerm.replaceAll(' ', '+');
  final url = Base.base_url + 'fictions/search?title=' + searchTerm;

  final response = await http.get(url);
  if (response.statusCode == 200) {
    var parsed = parse(response.body);
    var listResults = new List();
    
    for (var i in parsed.querySelectorAll('div.row.fiction-list-item')) {
      final link = i.querySelector('h2.fiction-title').querySelector('a');
      SearchInfo.getSearchInfo(i.querySelector('div.row.stats'));
      // listResults.add(BookSearchResult(aTag.attributes['href'],aTag.text,))
    }
  }
}

/*
def search_fiction(search_term): #search royalroad for a fiction using a given string
    search_term = search_term.replace(" ","+") #replace spaces with plus signs
    url = "https://www.royalroad.com/fictions/search?title="+str(search_term) #construct the url
    print(url) #print the search url for debug or console purposes
    soup = request_soup(url) #request the soup
    try:
        fiction_id = soup.find("div", attrs={"class":"col-sm-10 col-md-8 col-lg-9 col-xs-12 search-content"}).find("input").get("id").split("-")[1] #attempt to gather the first fiction id
    except: #there was no fiction id or the html is incorrect
        return None #return none
    return fiction_id #return the fiction id
 */

main() async {
  print(await search_fiction("Avarice"));
}
