class Book {
  final String url, title;
  final String imageUrl;

  Book(this.url, this.title, this.imageUrl);
}

class BookSearchResult {
  final Book book;
  final BookSearchInfo info;

  BookSearchResult(this.book, this.info);
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