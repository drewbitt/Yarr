import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

class FictionAllDetails {
  final FictionListResult fictionResult;
  final FictionDetails fictionDetails;

  FictionAllDetails({this.fictionResult, this.fictionDetails});
}

@JsonSerializable()
class Fiction {
  final int id;
  final String url, title, imageUrl;

  Fiction({this.id, this.url, this.title, this.imageUrl});

  factory Fiction.fromJson(Map<String, dynamic> json) =>
      _$FictionFromJson(json);
  Map<String, dynamic> toJson() => _$FictionToJson(this);
}

class FictionListResult {
  final Fiction book;
  final FictionListInfo info;

  FictionListResult({this.book, this.info});
}

// Info appearing in a search/display card for each fiction without visiting page
class FictionListInfo {
  List<String> genres;
  String descriptionText;
  int followers, pages, chapters, views;
  double rating;
  DateTime lastUpdate;

  FictionListInfo(
      {this.genres,
      this.followers,
      this.pages,
      this.chapters,
      this.views,
      this.rating,
      this.lastUpdate,
      this.descriptionText});
}

class FictionDetails {
  String author, descriptionHtml;
  int numChapters;
  List<ChapterDetails> chapterList;

  FictionDetails(
      {this.author, this.descriptionHtml, this.numChapters, this.chapterList});
}

// chapter when getting from a list
class ChapterDetails {
  String name, url;
  DateTime releaseDate;
  String releaseDateString;

  ChapterDetails(
      {this.name, this.url, this.releaseDate, this.releaseDateString});
}

// chapter when actually in the chapter, re-using ChapterDetails
class Chapter {
  int id;
  ChapterDetails chap;
  // title is title inside chapter in case it's different somehow?
  String title, contents;
  AuthorNote beginNote, endNote;

  Chapter(
      {this.id,
      this.chap,
      this.title,
      this.contents,
      this.beginNote,
      this.endNote});
}

class AuthorNote {
  String caption, noteBody;

  AuthorNote({this.caption, this.noteBody});
}

class ChapterComments {
  List<ChapterComment> comments;
  int numPages;

  ChapterComments({this.comments, this.numPages});
}

class ChapterComment {
  int id;
  DateTime postedDate;
  String postedDateString;
  String content;
  CommentAuthor commentAuthor;

  ChapterComment(
      {this.id,
      this.postedDate,
      this.postedDateString,
      this.content,
      this.commentAuthor});
}

class CommentAuthor {
  int id;
  String name;
  String avatar;

  CommentAuthor({this.id, this.name, this.avatar});
}
