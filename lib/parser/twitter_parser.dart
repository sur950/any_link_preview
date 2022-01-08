import 'package:html/dom.dart';
import 'og_parser.dart';
import 'util.dart';
import 'base.dart';

/// Parses [Metadata] from [<meta property='twitter:*'>] tags
class TwitterParser with BaseMetaInfo {
  /// The [document] to be parse
  final Document? _document;
  TwitterParser(this._document);

  /// Get [Metadata.title] from 'twitter:title'
  @override
  String? get title =>
      getProperty(_document, attribute: 'name', property: 'twitter:title') ??
      getProperty(_document, property: 'twitter:title');

  /// Get [Metadata.desc] from 'twitter:description'
  @override
  String? get desc =>
      getProperty(_document,
          attribute: 'name', property: 'twitter:description') ??
      getProperty(_document, property: 'twitter:description');

  /// Get [Metadata.image] from 'twitter:image'
  @override
  String? get image =>
      getProperty(_document, attribute: 'name', property: 'twitter:image') ??
      getProperty(_document, property: 'twitter:image');

  /// Twitter Cards do not have a url property so get the url from [og:url], if available.
  @override
  String? get url => OpenGraphParser(_document).url;

  @override
  String toString() => parse().toString();
}
