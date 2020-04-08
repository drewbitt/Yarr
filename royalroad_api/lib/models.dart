class Fiction {
  final String url, title;
  final String imageUrl;

  Fiction(this.url, this.title, this.imageUrl);
}

class FictionListResult {
  final Fiction book;
  final FictionListInfo info;

  FictionListResult(this.book, this.info);
}

class FictionListInfo {
  List<String> genres;
  String title, description, imageUrl;
  int followers, pages, chapters, views;
  double rating;
  DateTime lastUpdate;

  FictionListInfo(this.genres, this.followers, this.pages, this.chapters,
      this.views, this.rating, this.lastUpdate, this.description);
}

class FictionDetails {
  String author;
  int numChapters;
  List<ChapterDetails> chapterList;

  FictionDetails(this.author, this.numChapters, this.chapterList);
}

// chapter when getting from a list
class ChapterDetails {
  String name, url;
  DateTime releaseDate;
  String releaseDateString;

  ChapterDetails(this.name, this.url, this.releaseDate, this.releaseDateString);
}

// chapter when actually in the chapter, re-using ChapterDetails
class Chapter {
  int id;
  ChapterDetails chap;
  // title is title inside chapter in case it's different somehow?
  String title, contents;
  AuthorNote beginNote, endNote;

  Chapter(this.id, this.chap, this.title, this.contents, this.beginNote, this.endNote);
}

class AuthorNote {
  String caption, noteBody;

  AuthorNote(this.caption, this.noteBody);
}

class ChapterComments {
  List<ChapterComment> comments;
  int numPages;

  ChapterComments(this.comments, this.numPages);
}

class ChapterComment {
  int id;
  DateTime postedDate;
  String postedDateString;
  String content;
  CommentAuthor commentAuthor;

  ChapterComment(this.id, this.postedDate, this.postedDateString, this.content, this.commentAuthor);
}

class CommentAuthor {
  int id;
  String name;
  String avatar;

  CommentAuthor(this.id, this.name, this.avatar);
}
