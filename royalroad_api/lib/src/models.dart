class BookSearchResult {
  final String url, title;
  final String imageUrl;
  final BookSearchInfo info;

  BookSearchResult(this.url, this.title, this.imageUrl, this.info);
}

class BookSearchInfo {
  String title, description, imageUrl;
  int followers, pages, chapters, views;
  double rating;
  DateTime lastUpdate;

  BookSearchInfo(this.followers, this.pages, this.chapters,
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