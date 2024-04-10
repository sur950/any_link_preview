// ignore_for_file: omit_local_variable_types

import 'package:xml/xml.dart';

bool isValidSvg(String svgString) {
  try {
    final XmlDocument document = XmlDocument.parse(svgString);
    final XmlElement svgElement = document.rootElement;

    // Check if root element is 'svg'
    if (svgElement.name.local != 'svg') {
      return false;
    }

    // Validate 'viewBox' attribute if necessary
    final String? viewBox = svgElement.getAttribute('viewBox');
    if (viewBox != null) {
      final List<String> parts = viewBox.split(RegExp(r'\s+'));
      if (parts.length != 4 || parts.any((v) => double.tryParse(v) == null)) {
        return false; // 'viewBox' is incorrectly specified
      }
    }

    // Recursively check for at least one graphical element
    bool hasGraphicContent = _containsGraphicContent(svgElement);
    return hasGraphicContent;
  } catch (e) {
    // XML parsing error or other exception
    return false;
  }
}

bool _containsGraphicContent(XmlNode node) {
  if (node is XmlElement) {
    // Check if the current element is a graphical element
    if ([
      'circle',
      'ellipse',
      'line',
      'path',
      'polygon',
      'polyline',
      'rect',
      'text',
    ].contains(node.name.local)) {
      return true;
    }

    // Recursively check child elements
    for (XmlNode child in node.children) {
      if (_containsGraphicContent(child)) {
        return true;
      }
    }
  }

  return false;
}
