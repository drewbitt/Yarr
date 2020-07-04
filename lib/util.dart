import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterroad/service_locator.dart';
import 'package:flutterroad/services/localstorage_service.dart';
import 'package:royalroad_api/models.dart';

/// Utilizes cache if available
/// Returns loading spinner while loading. If error, returns error icon with onTap to retry.
ExtendedImage getImageUtil(url, {height = 100.0}) => ExtendedImage.network(
      url,
      height: height,
      scale: 0.1, // resizes images if too small
      cache: true,
      headers: {'User-Agent': 'Mozilla/5.0'},
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.failed) {
          return Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: Icon(Icons.error_outline,
                  size: 84.0), // 84 looks OK? testing needed
            ),
          );
        } else {
          return null;
        }
      },
    );

/// Checks if book is in library by comparing ids
bool isInLibrary(FictionListResult book) {
  final prefs = getIt.get<LocalStorageService>();
  return prefs.library.singleWhere((element) {
        final libraryBook = convertFictionJsonToFiction(element);
        return libraryBook.id == book.book.id;
      }, orElse: () => null) !=
      null;
}

void addToLibrary(FictionListResult book) {
  final prefs = getIt.get<LocalStorageService>();
  final bookJson = jsonEncode(book.book);
  prefs.library = new List.from(prefs.library)..add(bookJson);
}

void removeFromLibrary(FictionListResult book) {
  final prefs = getIt.get<LocalStorageService>();
  prefs.library = new List.from(prefs.library)..removeWhere((element) {
    final libraryBook = convertFictionJsonToFiction(element);
    return libraryBook.id == book.book.id;
  });
}

Fiction convertFictionJsonToFiction(String fictionJson) {
  final jsonBook = json.decode(fictionJson);
  return Fiction.fromJson(jsonBook);
}
