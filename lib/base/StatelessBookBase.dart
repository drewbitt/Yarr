import 'package:flutter/material.dart';
import 'package:royalroad_api/src/models.dart' show BookSearchResult;

abstract class StatelessBookBase extends StatelessWidget {

  final BookSearchResult book;
  StatelessBookBase(this.book);

  Image getImage(height) => Image.network(this.book.imageUrl, height: height);

}