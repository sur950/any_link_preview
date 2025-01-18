import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// I picked these links & images from internet
  static const String _errorImage =
      'https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg';
  static const String _url1 =
      'https://www.espn.in/football/soccer-transfers/story/4163866/transfer-talk-lionel-messi-tells-barcelona-hes-more-likely-to-leave-then-stay';
  static const String _url2 =
      'https://speakerdeck.com/themsaid/the-power-of-laravel-queues';
  static const String _url3 =
      'https://twitter.com/laravelphp/status/1222535498880692225';
  static const String _url4 = 'https://www.youtube.com/watch?v=W1pNjxmNHNQ';
  static const String _url5 = 'https://flutter.dev/';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Any Link Preview'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnyLinkPreview(
                link: _url1,
                displayDirection: UIDirection.uiDirectionHorizontal,
                cache: const Duration(hours: 1),
                backgroundColor: Colors.grey[300],
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: const Text('Oops!'),
                ),
                errorImage: _errorImage,
                userAgent: 'WhatsApp/2.21.12.21 A',
              ),
              const SizedBox(height: 25),
              const AnyLinkPreview(
                link: _url2,
                displayDirection: UIDirection.uiDirectionHorizontal,
                showMultimedia: false,
                bodyMaxLines: 5,
                titleStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                bodyStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 25),
              const AnyLinkPreview(
                displayDirection: UIDirection.uiDirectionHorizontal,
                link: _url3,
                errorTitle: 'Next one is a YouTube link, error title',
                errorBody: 'Show my custom error body',
              ),
              const SizedBox(height: 25),
              const AnyLinkPreview(link: _url4),
              const SizedBox(height: 25),
              const _CustomPreviewBuilder(url: _url5),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom widget that uses [AnyLinkPreview.builder] to show a custom preview
/// for the given link.
class _CustomPreviewBuilder extends StatelessWidget {
  final String url;

  const _CustomPreviewBuilder({
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return AnyLinkPreview.builder(
      link: url,
      itemBuilder: (context, metadata, imageProvider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageProvider != null)
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).width * 0.5,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Container(
            color: Theme.of(context).primaryColor.withOpacity(0.6),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (metadata.title != null)
                  Text(
                    metadata.title!,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 5),
                if (metadata.desc != null)
                  Text(
                    metadata.desc!,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                Text(
                  metadata.url ?? url,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
