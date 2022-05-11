import 'package:html/dom.dart';

extension GetMethod on Map {
  String? get(dynamic key) {
    var value = this[key];
    if (value is List) return value.first;
    return value.toString();
  }

  dynamic getDynamic(dynamic key) {
    return this[key];
  }
}

String? getDomain(String url) {
  return Uri.parse(url).host.toString().split('.')[0];
}

String? getProperty(
  Document? document, {
  String tag = 'meta',
  String attribute = 'property',
  String? property,
  String key = 'content',
}) {
  var value_ = document
      ?.getElementsByTagName(tag)
      .cast<Element?>()
      .firstWhere((element) => element?.attributes[attribute] == property,
          orElse: () => null)
      ?.attributes
      .get(key);
  // print(value_);
  return value_;
}
