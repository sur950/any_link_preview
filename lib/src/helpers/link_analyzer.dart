// ignore_for_file: sdk_version_since

import 'dart:async' as async;
import 'dart:convert';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:any_link_preview/src/utilities/http_redirect_check.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:string_validator/string_validator.dart';

import '../parser/html_parser.dart';
import '../parser/json_ld_parser.dart';
import '../parser/og_parser.dart';
import '../parser/other_parser.dart';
import '../parser/twitter_parser.dart';
import '../parser/util.dart';
import 'cache_manager.dart';

class LinkAnalyzer {
  /// Checks whether a string is not empty, doesn't contain a `'null'` string,
  /// and not blank
  static bool isNotEmpty(String? str) {
    return str != null &&
        str.trim().isNotEmpty &&
        str.trim().toLowerCase() != 'null';
  }

  /// Checks whether a string is empty, contains a `'null'` string, or is blank.
  static bool isEmpty(String? str) {
    return str == null ||
        str.trim().isEmpty ||
        str.trim().toLowerCase() == 'null';
  }

  /// Returns [Metadata] from cache if available.
  static Future<Metadata?> getInfoFromCache(String url) async {
    Metadata? info_;

    try {
      final infoJson = await CacheManager.getJson(key: url);
      if (infoJson != null) {
        info_ = Metadata.fromJson(infoJson);
        var isEmpty_ = info_.title == null || info_.title == 'null';
        if (isEmpty_ || !info_.timeout.isAfter(DateTime.now())) {
          async.unawaited(CacheManager.deleteKey(url));
        }
        if (isEmpty_) info_ = null;
      }
    } catch (e) {
      debugPrint('Error while retrieving cache data => $e');
    }

    return info_;
  }

  /// Deletes [Metadata] from cache if present.
  static void _deleteFromCache(String url) {
    try {
      async.unawaited(CacheManager.deleteKey(url));
    } catch (e) {
      debugPrint('Error retrieving cache data => $e');
    }
  }

  /// Twitter generates meta tags client-side so it's impossible to read their
  /// values from a server request. We use this hack to fetch server-side
  /// rendered meta tags.
  ///
  /// This method is useful for URLs that use client-side meta tag generation
  /// technique.
  static Future<Metadata?> getInfoClientSide(
    String url, {
    Duration? cache = const Duration(hours: 24),
    Map<String, String> headers = const {},
    // 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko)',
    // 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',
    String? userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
  }) =>
      getInfo(
        url,
        cache: cache,
        headers: headers,
        userAgent: userAgent
      );

  /// Fetches a [url], validates it, then returns [Metadata].
  static Future<Metadata?> getInfo(
    String url, {
    Duration? cache = const Duration(hours: 24),
    Map<String, String> headers = const {},
    String? userAgent,
  }) async {
    Metadata? info;
    if ((cache?.inSeconds ?? 0) > 0) {
      info = await getInfoFromCache(url);
    } else {
      _deleteFromCache(url);
    }
    if (info != null) return info;

    if (!isURL(url)) return null;

    // Default values; Domain name as the [title],
    // URL as the [description]
    info?.title = getDomain(url);
    info?.desc = url;
    info?.siteName = getDomain(url);
    info?.url = url;

    try {
      // Make our network call
      final response = await fetchWithRedirects(
        url,
        headers: headers,
        userAgent: userAgent,
      );
      final headerContentType = response.headers['content-type'];

      if (headerContentType != null && headerContentType.startsWith('image/')) {
        info?.title = '';
        info?.desc = '';
        info?.siteName = '';
        info?.image = url;
        return info;
      }

      final document = responseToDocument(response);
      if (document == null) return info;

      final data_ = _extractMetadata(document, url: url);

      if (data_ == null) {
        return info;
      } else if (cache != null) {
        data_.timeout = DateTime.now().add(cache);
        await CacheManager.setJson(key: url, value: data_.toJson());
      }

      return data_;
    } catch (error) {
      debugPrint('AnyLinkPreview - Error in $url response ($error)');
      // Any sort of exceptions due to wrong URL's, host lookup failure etc.
      return null;
    }
  }

  /// Takes an [http.Response] and returns a [Document].
  static Document? responseToDocument(http.Response response) {
    if (response.statusCode != 200) return null;

    Document? document;
    try {
      document = parse(utf8.decode(response.bodyBytes));
    } catch (err) {
      return document;
    }

    return document;
  }

  /// Returns instance of [Metadata] with data extracted from the
  /// [Document]. Provide a [url] as a fallback when there are no
  /// Document URLs extracted by the parsers.
  ///
  /// Future: Can pass in a strategy, e.g.: to retrieve only OpenGraph, or
  /// OpenGraph and Json+LD only.
  static Metadata? _extractMetadata(Document document, {String? url}) {
    return _parse(document, url: url);
  }

  /// This is the default strategy for building our [Metadata].
  ///
  /// It tries [OpenGraphParser], then [TwitterParser], then [JsonLdParser],
  /// and then falls back to [HtmlMetaParser] tags for missing data. You may
  /// optionally provide a URL to the function, used to resolve relative images
  /// or to compensate for the lack of URI identifiers from the metadata
  /// parsers.
  static Metadata _parse(Document? document, {String? url}) {
    final output = Metadata();

    final parsers = [
      _openGraph(document),
      _twitterCard(document),
      _jsonLdSchema(document),
      _htmlMeta(document),
      _otherParser(document),
    ];

    for (final p in parsers) {
      if (p == null) break;

      output.title ??= p.title;
      output.desc ??= p.desc;
      output.image ??= p.image;
      output.siteName ??= p.siteName;
      output.url ??= p.url ?? url;

      if (output.hasAllMetadata) break;
    }
    // If the parsers did not extract a URL from the metadata, use the given
    // url, if available. This is used to attempt to resolve relative images.
    final url_ = output.url ?? url;
    final image = output.image;
    if (url_ != null && image != null) {
      output.image = Uri.parse(url_).resolve(image).toString();
    }

    return output;
  }

  static Metadata? _openGraph(Document? document) {
    try {
      return OpenGraphParser(document).parse();
    } catch (e) {
      return null;
    }
  }

  static Metadata? _htmlMeta(Document? document) {
    try {
      return HtmlMetaParser(document).parse();
    } catch (e) {
      return null;
    }
  }

  static Metadata? _jsonLdSchema(Document? document) {
    try {
      return JsonLdParser(document).parse();
    } catch (e) {
      return null;
    }
  }

  static Metadata? _twitterCard(Document? document) {
    try {
      return TwitterParser(document).parse();
    } catch (e) {
      return null;
    }
  }

  static Metadata? _otherParser(Document? document) {
    try {
      return OtherParser(document).parse();
    } catch (e) {
      return null;
    }
  }
}
