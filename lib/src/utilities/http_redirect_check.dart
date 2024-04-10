// ignore_for_file: omit_local_variable_types

import 'package:http/http.dart' as http;

Future<http.Response> fetchWithRedirects(
  String url, {
  int maxRedirects = 7,
  Map<String, String> headers = const {},
  String? userAgent,
}) async {
  String userAgentFallback =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3';
  Map<String, String>? allHeaders = {
    ...headers,
    'User-Agent': userAgent ?? userAgentFallback
  };
  var response = await http.get(Uri.parse(url), headers: allHeaders);
  int redirectCount = 0;

  // print(_isRedirect(response));
  while (_isRedirect(response) && redirectCount < maxRedirects) {
    String? location = response.headers['location'];
    if (location == null) {
      throw Exception('HTTP redirect without Location header');
    }

    response = await http.get(Uri.parse(location), headers: allHeaders);
    redirectCount++;
  }

  if (redirectCount >= maxRedirects) {
    throw Exception('Maximum redirect limit reached');
  }

  return response;
}

bool _isRedirect(http.Response response) {
  return [301, 302, 303, 307, 308].contains(response.statusCode);
}
