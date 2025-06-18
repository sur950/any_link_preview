import 'package:http/http.dart' as http;

Future<http.Response> fetchWithRedirects(
  String url, {
  int maxRedirects = 7,
  Map<String, String> headers = const {},
  String? userAgent,
}) async {
  const userAgentFallback = 'WhatsApp/2.21.12.21 A';
  Map<String, String>? allHeaders = {
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

Future<http.Response> getYoutubeData(
  String videoId, {
  Map<String, String>? headers,
  String? userAgent,
}) async {
  const userAgentFallback = 'WhatsApp/2.21.12.21 A';
  Map<String, String>? allHeaders = {
    ...?headers,
    'User-Agent': userAgent ?? userAgentFallback,
  };
  var response = await http.get(
    Uri.parse(
      'https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=$videoId&format=json',
    ),
    headers: allHeaders,
  );
  return response;
}

String? getYouTubeVideoId(String url) {
  // Regular expression pattern to detect YouTube URLs
  // with or without a proxy prefix
  final regExp = RegExp(
    r'(?:https?:\/\/)?(?:[^\/]+\.)?(?:youtube\.com\/(?:watch\?v=|embed\/|v\/|v\/|.+\?v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
  );

  // Apply the regex to the URL
  final match = regExp.firstMatch(url);

  // If a match is found, return the first capture group, which is the video ID
  return match?.group(1);
}
