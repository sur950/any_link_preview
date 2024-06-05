import 'package:html/dom.dart';

extension GetMethod on Map {
  String? get(dynamic key) {
    final value = this[key];
    if (value is List) return value.first;
    return value?.toString();
  }

  dynamic getDynamic(dynamic key) {
    return this[key];
  }
}

String? getDomain(String url) {
  return Uri.parse(url).host.split('.')[0];
}

String? getProperty(
  Document? document, {
  String tag = 'meta',
  String attribute = 'property',
  String? property,
  String key = 'content',
}) {
  final value_ = document
      ?.getElementsByTagName(tag)
      .cast<Element?>()
      .firstWhere(
        (element) => element?.attributes[attribute] == property,
        orElse: () => null,
      )
      ?.attributes
      .get(key);

  return value_;
}
