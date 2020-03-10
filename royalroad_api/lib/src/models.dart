class BookSearchResult {
  final String url, title;
  final String imageUrl;
  final BookSearchInfo info;

  BookSearchResult(this.url, this.title, this.imageUrl, this.info);
}

class BookSearchInfo {
  List<String> genres;
  String title, description, imageUrl;
  int followers, pages, chapters, views;
  double rating;
  DateTime lastUpdate;

  BookSearchInfo(this.genres, this.followers, this.pages, this.chapters,
      this.views, this.rating, this.lastUpdate, this.description);
}

class BookDetails {
  String author;
  int numChapters;
  List<BookChapter> chapterList;

  BookDetails(this.author, this.numChapters, this.chapterList);
}

class BookChapter {
  String name, url;
  DateTime releaseDate;

  BookChapter(this.name, this.url, this.releaseDate);
}

class BookChapterContents {
  BookChapter chap;
  // title is title inside chapter in case it's different somehow?
  String title, contents;

  BookChapterContents(this.chap, this.title, this.contents);
}