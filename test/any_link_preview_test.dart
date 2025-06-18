import 'package:flutter_test/flutter_test.dart';

import 'package:any_link_preview/any_link_preview.dart';

void main() {
  group('AnyLinkPreview.isValidLink', () {
    test('returns true for a valid url', () {
      const url = 'https://example.com';
      expect(AnyLinkPreview.isValidLink(url), isTrue);
    });

    test('returns false for an invalid url', () {
      const url = 'not a url';
      expect(AnyLinkPreview.isValidLink(url), isFalse);
    });
  });
}
