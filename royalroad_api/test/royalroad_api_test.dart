import 'package:test/test.dart';
import 'package:royalroad_api/royalroad_api.dart';

void main() {
  test('Search single novel', () async {
    final result = await searchFiction('King of Avarice');
    expect(result[0].book.title, 'The King of Avarice');
  });
  
  test('Novel details test', () async {
    final result = await getBookDetails('https://www.royalroad.com/fiction/5364/from-angel-to-vampire');
    expect(result.numChapters, 1);
    for (var i in result.chapterList) {
      expect(i.releaseDate.toString(), '2016-02-17 02:49:00.000');
      expect(i.name, 'Chap. 1: Their mother');
      expect(i.url, 'https://www.royalroad.com/fiction/5364/from-angel-to-vampire/chapter/54328/chap-1-their-mother');
    }
    expect(result.author, 'yukinekoaquaneko');
  });

  test('Chapter content test', () async {
    // Same url as novel details test
    final result = await getBookDetails('https://www.royalroad.com/fiction/5364/from-angel-to-vampire');
    final chap_result = await getChapter(result.chapterList[0]);

    expect(chap_result.contents, startsWith('<div class="chapter-inner chapter-content">'));
  });
}
