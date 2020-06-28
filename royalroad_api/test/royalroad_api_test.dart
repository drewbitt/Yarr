import 'package:test/test.dart';
import 'package:royalroad_api/royalroad_api.dart';

void main() {
  test('Search single novel', () async {
    final result = await searchFiction('King of Avarice');
    expect(result[0].book.title, 'The King of Avarice');
  });

  test('Novel details test', () async {
    final result = await getFictionDetails(
        'https://www.royalroad.com/fiction/5364/from-angel-to-vampire');
    expect(result.numChapters, 1);
    for (var i in result.chapterList) {
      expect(i.releaseDate.toString(), '2016-02-17 02:49:00.000');
      expect(i.name, 'Chap. 1: Their mother');
      expect(i.url,
          'https://www.royalroad.com/fiction/5364/from-angel-to-vampire/chapter/54328/chap-1-their-mother');
    }
    expect(result.author, 'yukinekoaquaneko');
  });

  test('Chapter content test', () async {
    // Same url as novel details test
    final result = await getFictionDetails(
        'https://www.royalroad.com/fiction/5364/from-angel-to-vampire');
    final chap_result = await getChapter(result.chapterList[0]);

    expect(chap_result.contents, isNotNull);
  });

  test('Chapter note tests', () async {
    final result = await getFictionDetails(
        'https://www.royalroad.com/fiction/16946/azarinth-healer');
    final chap_result = await getChapter(result.chapterList[3]);

    expect(chap_result.beginNote, isNotNull);
    expect(chap_result.endNote, isNotNull);
  });

  test('Chapter comment test', () async {
    final result = await getFictionDetails(
        'https://www.royalroad.com/fiction/16946/azarinth-healer');
    final chap_result = await getChapter(result.chapterList[3]);
    final comments = await getComments(chap_result.id);

    expect(comments.numPages, greaterThan(0));
    expect(comments.comments.length, greaterThan(0));
  });

  test('a', () async {
    final result = await getFictionDetails('https://www.royalroad.com/fiction/33083/the-hidden-paladin-the-world-of-the-undead-force');
    final chap_result = await getChapter(result.chapterList[result.chapterList.length-4]);
    final comments = await getComments(chap_result.id);

    comments.comments.forEach((element) {
      print(element.content);
    });

  });

  test('Trending fictions test', () async {
    final result = await getTrendingFictions();
    expect(result.length, greaterThan(0));
  });

  test('Weekly popular fictions test', () async {
    final result = await getWeeksPopularFictions();
    expect(result.length, greaterThan(0));
  });

  test('Best rated fictions test', () async {
    final result = await getBestRatedFictions();
    expect(result.length, greaterThan(0));
  });
}
