import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'svg_validator.dart';

class ImageProviderValue {
  final ImageProvider? image;
  final SvgPicture? svgImage;

  const ImageProviderValue(this.image, this.svgImage);
}

/// Builds an ImageProvider or SvgPicture based on the given input.
ImageProviderValue buildImageProvider(
  String? imageUrl,
  String? errorImageUrl, {
  Widget? placeholder,
  Widget? errorPlaceholder,
}) {
  try {
    // Handle Base64-encoded images
    if (imageUrl != null && imageUrl.startsWith('data:image')) {
      if (isSvgDataUri(imageUrl)) {
        final svgContent = extractSvgContent(imageUrl);
        if (svgContent != null) {
          final isValidSVG = isValidSvg(svgContent);
          debugPrint(
            isValidSVG
                ? 'Valid SVG data found.'
                : 'Invalid SVG data; using fallback image.',
          );
          if (isValidSVG) {
            return ImageProviderValue(
              null,
              SvgPicture.string(
                svgContent,
                placeholderBuilder: (context) =>
                    placeholder ??
                    Container(
                      color: Colors.grey,
                      child: const Text('Loading...'),
                    ),
                errorBuilder: (context, error, stackTrace) =>
                    errorPlaceholder ??
                    Container(
                      color: Colors.red,
                      child: const Text('Error loading SVG.'),
                    ),
              ),
            );
          } else if (errorImageUrl != null) {
            return ImageProviderValue(NetworkImage(errorImageUrl), null);
          }
        }
      } else {
        // Handle other Base64-encoded images
        return ImageProviderValue(
          buildBase64Image(imageUrl, errorImageUrl),
          null,
        );
      }
    } else if (imageUrl != null && imageUrl.endsWith('.svg')) {
      // Check if the URL is for an SVG image
      return ImageProviderValue(
        null,
        SvgPicture.network(
          imageUrl,
          placeholderBuilder: (context) =>
              placeholder ??
              Container(
                color: Colors.grey,
                child: const Text('Loading...'),
              ),
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading SVG: $error');
            return errorPlaceholder ??
                Container(
                  color: Colors.red,
                  child: const Text('Error loading SVG.'),
                );
          },
        ),
      );
    }

    // Handle regular image URLs
    if (imageUrl != null) {
      return ImageProviderValue(
        buildNetworkImage(imageUrl, errorImageUrl),
        null,
      );
    }

    // If no image was created, fallback to the error image
    if (errorImageUrl != null) {
      return ImageProviderValue(NetworkImage(errorImageUrl), null);
    }
  } catch (e) {
    debugPrint('Image parsing failed -> $e');
    if (errorImageUrl != null) {
      return ImageProviderValue(NetworkImage(errorImageUrl), null);
    }
  }

  // Return null if no valid image or fallback was created
  return const ImageProviderValue(null, null);
}

/// Checks if the input is a Base64-encoded SVG data URI.
bool isSvgDataUri(String data) {
  return data.contains('data:image/svg+xml');
}

/// Extracts and decodes SVG content from a Base64-encoded data URI.
String? extractSvgContent(String data) {
  try {
    if (data.contains('base64,')) {
      final base64String = data.substring(data.indexOf('base64,') + 7);
      return utf8.decode(base64.decode(base64String));
    } else {
      return kIsWeb
          ? Uri.decodeComponent(
              data.substring('data:image/svg+xml,'.length),
            )
          : Uri.decodeFull(data.substring('data:image/svg+xml,'.length));
    }
  } catch (e) {
    debugPrint('Failed to decode SVG content -> $e');
    return null;
  }
}

/// Builds an image from a Base64-encoded data URI.
ImageProvider? buildBase64Image(String data, String? errorImageUrl) {
  try {
    return MemoryImage(
      base64Decode(data.substring(data.indexOf('base64,') + 7)),
    );
  } catch (e) {
    debugPrint('Invalid Base64 data -> $e');
    return errorImageUrl != null ? NetworkImage(errorImageUrl) : null;
  }
}

/// Builds a network image after validating the URL.
ImageProvider? buildNetworkImage(String url, String? errorImageUrl) {
  if (isValidUrl(url)) {
    return NetworkImage(url);
  } else {
    debugPrint('Invalid image URL: $url');
    return errorImageUrl != null ? NetworkImage(errorImageUrl) : null;
  }
}

/// Checks if a URL is valid.
bool isValidUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri != null && uri.hasAbsolutePath;
}
