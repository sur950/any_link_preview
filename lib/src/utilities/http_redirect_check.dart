import 'package:http/http.dart' as http;

Future<http.Response> fetchWithRedirects(
  String url, {
  int maxRedirects = 7,
  Map<String, String> headers = const {},
  String? userAgent,
}) async {
  const userAgentFallback =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3';
  final allHeaders = <String, String>{
    ...headers,
    'User-Agent': userAgent ?? userAgentFallback,
  };
  var response = await http.get(Uri.parse(url), headers: allHeaders);
  var redirectCount = 0;

  while (_isRedirect(response) && redirectCount < maxRedirects) {
    final location = response.headers['location'];
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
