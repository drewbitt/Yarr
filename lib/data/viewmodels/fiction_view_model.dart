import 'package:royalroad_api/models.dart';

// Will mess with proper viewmodels later

int translateListIndex(int index, int fullChapterListLength) {
  final rangeIndexList = Iterable<int>.generate(9).toList();
  final bumpVal = fullChapterListLength - 9;
  final indexOfIndex = rangeIndexList.indexOf(index);
  return rangeIndexList.map((e) => e + bumpVal).toList()[indexOfIndex];
}

List<ChapterDetails> getChapterListPreview(
    List<ChapterDetails> chapterList, bool reverseList) {
  int minLength = chapterList.length < 9 ? chapterList.length - 1 : 8;
  return reverseList
      ? chapterList.reversed
          .toList()
          .sublist(0, minLength + 1)
          .reversed
          .toList()
      : chapterList.sublist(0, minLength + 1);
}
