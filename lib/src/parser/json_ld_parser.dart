import 'dart:convert';
import 'package:html/dom.dart';
import 'util.dart';
import 'base.dart';

/// Parses [Metadata] from `json-ld` data in `<script>`
class JsonLdParser with BaseMetaInfo {
  /// The [document] to be parse
  Document? document;
  dynamic _jsonData;

  JsonLdParser(this.document) {
    _jsonData = _parseToJson(document);
  }

  dynamic _parseToJson(Document? document) {
    final data = document?.head
        ?.querySelector("script[type='application/ld+json']")
        ?.innerHtml;
    if (data == null) return null;
    /* For multiline json file */
    // Replacing all new line characters with empty space
    // before performing json decode on data
    var d = jsonDecode(data.replaceAll('\n', ' '));
    return d;
  }

  /// Get the [Metadata.title] from the [<title>] tag
  @override
  String? get title {
    final data = _jsonData;
    if (data is List) {
      return data.first['name'];
    } else if (data is Map) {
      return data.get('name') ?? data.get('headline');
    }
    return null;
  }

  /// Get the [Metadata.desc] from the <meta name="description" content=""> tag
  @override
  String? get desc {
    final data = _jsonData;
    if (data is List) {
      return data.first['description'] ?? data.first['headline'];
    } else if (data is Map) {
      return data.get('description') ?? data.get('headline');
    }
    return null;
  }

  /// Get the [Metadata.image] from the first <img> tag in the body
  @override
  String? get image {
    final data = _jsonData;
    if (data is List && data.isNotEmpty) {
      return _imgResultToStr(data.first['logo'] ?? data.first['image']);
    } else if (data is Map) {
      return _imgResultToStr(
          data.getDynamic('logo') ?? data.getDynamic('image'));
    }
    return null;
  }

  String? _imgResultToStr(dynamic result) {
    if (result is List && result.isNotEmpty) result = result.first;
    if (result is String) return result;
    return null;
  }

  @override
  String toString() => parse().toString();
}
