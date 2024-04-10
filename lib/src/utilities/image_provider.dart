import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'svg_validator.dart';

class ImageProviderValue {
  ImageProvider? image;
  SvgPicture? svgImage;

  ImageProviderValue(this.image, this.svgImage);
}

ImageProviderValue buildImageProvider(String? image, String? errorImage) {
  ImageProvider? imageProvider;
  SvgPicture? svgImageProvider;
  try {
    if (image != null && image.startsWith('data:image')) {
      if (image.contains('data:image/svg+xml')) {
        String svgContent;
        if (image.contains('base64,')) {
          // Extract and decode the base64-encoded SVG
          var base64String = image.substring(image.indexOf('base64,') + 7);
          svgContent = utf8.decode(base64.decode(base64String));
        } else {
          // Direct SVG content
          svgContent = kIsWeb
              ? Uri.decodeComponent(
                  image.substring('data:image/svg+xml,'.length))
              : Uri.decodeFull(image.substring('data:image/svg+xml,'.length));
        }

        var isValidSVG = isValidSvg(svgContent);

        if (isValidSVG) {
          svgImageProvider = SvgPicture.string(
            svgContent,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => Container(color: Colors.grey),
          );
        } else if (!isValidSVG && errorImage != null) {
          imageProvider = NetworkImage(errorImage);
        }
      } else {
        // Handling other image types (e.g., JPEG, PNG) encoded in base64
        imageProvider = MemoryImage(
          base64Decode(image.substring(image.indexOf('base64') + 7)),
        );
      }
    } else if (image != null) {
      // Handling direct URLs to images
      imageProvider = NetworkImage(image);
    }

    if (svgImageProvider == null &&
        imageProvider == null &&
        errorImage != null) {
      imageProvider = NetworkImage(errorImage);
    }
  } catch (error) {
    debugPrint('Image parsing failed -> $error');
  }

  return ImageProviderValue(imageProvider, svgImageProvider);
}
