import 'package:flutter/material.dart';
import 'package:royalroad_api/models.dart' show BookListResult;

abstract class StatelessBookBase extends StatelessWidget {
  final BookListResult book;
  StatelessBookBase(this.book);

  // Scale makes tiny images larger but they may look bad
  Image getImage({height}) =>
      Image.network(this.book.book.imageUrl, height: height, scale: 0.1);
}
