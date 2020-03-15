class Book {
  final String url, title;
  final String imageUrl;

  Book(this.url, this.title, this.imageUrl);
}

class BookListResult {
  final Book book;
  final BookListInfo info;

  BookListResult(this.book, this.info);
}

class BookListInfo {
  List<String> genres;
  String title, description, imageUrl;
  int followers, pages, chapters, views;
  double rating;
  DateTime lastUpdate;

  BookListInfo(this.genres, this.followers, this.pages, this.chapters,
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
  String releaseDateString;

  BookChapter(this.name, this.url, this.releaseDate, this.releaseDateString);
}

class BookChapterContents {
  BookChapter chap;
  // title is title inside chapter in case it's different somehow?
  String title, contents;

  BookChapterContents(this.chap, this.title, this.contents);
}