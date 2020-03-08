class BookSearchResult {
  String url, title;
  BookSearchInfo info;

  BookSearchResult(this.url, this.title, this.info);
}

class BookSearchInfo {
  String title;
  int followers, pages, chapters, views;
  double rating;
  DateTime lastUpdate;
  String description;

  BookSearchInfo(this.followers, this.pages, this.chapters,
      this.views, this.rating, this.lastUpdate, this.description);
}