import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:royalroad_api/models.dart' show BookListResult;

abstract class StatelessBookBase extends StatelessWidget {
  final BookListResult book;
  StatelessBookBase(this.book);

  ExtendedImage getImage({height}) => ExtendedImage.network(
        this.book.book.imageUrl,
        height: height,
        scale: 0.1,
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
}
