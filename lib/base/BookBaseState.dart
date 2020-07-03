import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/util.dart';
import 'package:royalroad_api/models.dart';

@optionalTypeArgs
abstract class BookBaseState<T extends StatefulWidget> extends State {
  final FictionListResult book;
  BookBaseState(this.book);

  /// Returns book cover image from network resized to height, utilizing cache if available
  /// Returns loading spinner while loading. If error, returns error icon with onTap to retry.
  ExtendedImage getImage({height = 100.0}) =>
      getImageUtil(this.book.book.imageUrl, height: height);
}
