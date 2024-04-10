/// The base class for implementing a parser
mixin MetadataKeys {
  static const kTitle = 'title';
  static const kDescription = 'description';
  static const kImage = 'image';
  static const kUrl = 'url';
  static const kSiteName = 'siteName';
  static const kTimeout = 'timeout';
}

mixin BaseMetaInfo {
  String? title;
  String? desc;
  String? image;
  String? url;
  String? siteName;

  /// Returns `true` if any parameter other than [url] is filled
  bool get hasData =>
      ((title?.isNotEmpty ?? false) && title != 'null') ||
      ((desc?.isNotEmpty ?? false) && desc != 'null') ||
      ((image?.isNotEmpty ?? false) && image != 'null');

  Metadata parse() {
    final m = Metadata();
    m.title = title;
    m.desc = desc;
    m.image = image;
    m.url = url;
    m.siteName = siteName;
    return m;
  }
}

abstract class InfoBase {
  late DateTime timeout;
}

/// Container class for Metadata
class Metadata extends InfoBase with BaseMetaInfo, MetadataKeys {
  bool get hasAllMetadata {
    return title != null && desc != null && image != null && url != null;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  Map<String, dynamic> toMap() {
    return {
      MetadataKeys.kTitle: title,
      MetadataKeys.kDescription: desc,
      MetadataKeys.kImage: image,
      MetadataKeys.kSiteName: siteName,
      MetadataKeys.kUrl: url,
      MetadataKeys.kTimeout: timeout.millisecondsSinceEpoch ~/ 1000,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  static Metadata fromJson(Map<String, dynamic> json) {
    final m = Metadata();
    m.title = json[MetadataKeys.kTitle];
    m.desc = json[MetadataKeys.kDescription];
    m.image = json[MetadataKeys.kImage];
    m.siteName = json[MetadataKeys.kSiteName];
    m.url = json[MetadataKeys.kUrl];
    m.timeout = DateTime.fromMillisecondsSinceEpoch(
        json[MetadataKeys.kTimeout]! * 1000);
    return m;
  }
}
