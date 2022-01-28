import 'package:html/dom.dart';
import 'util.dart';
import 'base.dart';

/// Parses [Metadata] from [<meta property='og:*'>] tags
class OpenGraphParser with BaseMetaInfo {
  /// The [document] to be parse
  final Document? _document;
  OpenGraphParser(this._document);

  /// Get [Metadata.title] from 'og:title'
  @override
  String? get title => getProperty(_document, property: 'og:title');

  /// Get [Metadata.desc] from 'og:description'
  @override
  String? get desc => getProperty(_document, property: 'og:description');

  /// Get [Metadata.image] from 'og:image'
  @override
  String? get image => getProperty(_document, property: 'og:image');

  /// Get [Metadata.url] from 'og:url'
  @override
  String? get url => getProperty(_document, property: 'og:url');

  @override
  String toString() => parse().toString();
}
