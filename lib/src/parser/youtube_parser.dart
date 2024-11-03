import 'dart:convert';
import 'package:html/dom.dart';
import 'base.dart';
import 'util.dart';

class YoutubeParser with BaseMetaInfo {
  /// The [document] to be parse
  Document? document;
  dynamic _jsonData;

  YoutubeParser(this.document) {
    _jsonData = _parseToJson(document);
  }

  dynamic _parseToJson(Document? document) {
    final data = document?.outerHtml
        .replaceAll('<html><head></head><body>', '')
        .replaceAll('</body></html>', '');
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
      return data.first['title'];
    } else if (data is Map) {
      return data.get('title');
    }
    return null;
  }

  /// Get the [Metadata.image] from the first <img> tag in the body
  @override
  String? get image {
    final data = _jsonData;
    if (data is List && data.isNotEmpty) {
      return _imgResultToStr(data.first['thumbnail_url']);
    } else if (data is Map) {
      return _imgResultToStr(data.getDynamic('thumbnail_url'));
    }
    return null;
  }

  @override
  String? get siteName {
    final data = _jsonData;
    if (data is List) {
      return data.first['provider_name'];
    } else if (data is Map) {
      return data.get('provider_name');
    }
    return null;
  }

  @override
  String? get url {
    final data = _jsonData;
    if (data is List) {
      return data.first['provider_url'];
    } else if (data is Map) {
      return data.get('provider_url');
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
