import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// Utilizes cache if available
/// Returns loading spinner while loading. If error, returns error icon with onTap to retry.
ExtendedImage getImageUtil(url, {height=100.0}) => ExtendedImage.network(
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
