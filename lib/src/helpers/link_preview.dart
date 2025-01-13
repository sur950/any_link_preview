import 'dart:async';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:any_link_preview/src/parser/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/image_provider.dart';
import '../widgets/link_view_horizontal.dart';
import '../widgets/link_view_vertical.dart';
import 'link_analyzer.dart';

enum UIDirection { uiDirectionVertical, uiDirectionHorizontal }

class AnyLinkPreview extends StatefulWidget {
  /// Display direction. Either [UIDirection.uiDirectionVertical] or
  /// [UIDirection.uiDirectionHorizontal]. Defaults to vertical direction.
  final UIDirection displayDirection;

  /// Represents the mechanism used to open URLs via [launchUrl]. Defaults to
  /// [LaunchMode.platformDefault]
  final LaunchMode urlLaunchMode;

  /// URL represented in string. For IOS & Web, only HTTP and HTTPS are
  /// supported. For Android, all URLs are supported.
  final String link;

  /// Customize background color. Defaults to `Color.fromRGBO(235, 235, 235, 1)`
  final Color? backgroundColor;

  /// Placeholder widget that is shown while the metadata request is pending.
  /// If not present, the default loading widget will be shown.
  final Widget? placeholderWidget;

  /// Error widget that will be shown in case of an error. Defaults to a plain
  /// [Container] with a given [backgroundColor]. If the issue is known, i.e.
  /// either a title or a description of the error is present, [errorTitle] and
  /// [errorBody] are used instead, with fallback to their default values.
  final Widget? errorWidget;

  /// Error title message that will be shown in case of an error. Defaults to
  /// "Something went wrong!".
  final String? errorTitle;

  /// Error body message that will be shown in case of an error. Defaults to
  /// "Oops! Unable to parse the url. We have sent feedback to our developers &
  /// we will try to fix this in our next release. Thanks!"
  final String? errorBody;

  /// Image that will be shown in case of an error when [showMultimedia] is set
  /// to `true` and no metadata could be parsed. Defaults to
  /// "A semi-soccer ball image that looks like crying".
  final String? errorImage;

  /// Sets the overflow type for body text (description) of the link.
  /// Deaults to [TextOverflow.ellipsis].
  final TextOverflow bodyTextOverflow;

  /// Sets the limit to body text (description) of the link. Defaults to `3`.
  final int bodyMaxLines;

  /// TTL of metadata cache. Defaults to 1 day. Pass `null` to disable caching
  /// and always make a request for latest metadata.
  final Duration cache;

  /// Customize body [TextStyle].
  final TextStyle? titleStyle;

  /// Customize body [TextStyle].
  final TextStyle? bodyStyle;

  /// Whether to show metadata image if it's present. Defaults to `true`.
  final bool showMultimedia;

  /// [BorderRadius] for the card. Deafults to `12`.
  final double? borderRadius;

  /// If set to true, removes card widget's elevation. Defaults to `false`.
  final bool removeElevation;

  /// Box shadow for the card. Deafults to
  /// `[BoxShadow(blurRadius: 3, color: Colors.grey)]`.
  final List<BoxShadow>? boxShadow;

  /// Proxy URL that is used to resolve CORS issues on web.
  /// For example, `https://cors-anywhere.herokuapp.com/` .
  final String? proxyUrl;

  /// Headers to be added in the HTTP request to the link
  final Map<String, String>? headers;

  /// Function that is called on card tap. If not provided, then [launchUrl]
  /// will be used with the provided link. To disable calling [launchUrl] and
  /// instead do nothing on tap, pass an empty function: `() {}`.
  final VoidCallback? onTap;

  /// Height of the preview card. Defaults to
  /// `(MediaQuery.sizeOf(context).height) * 0.15` for the horizontal preview
  /// and `(MediaQuery.sizeOf(context).height) * 0.25` for the vertical preview.
  final double? previewHeight;

  /// Builder function that is used only in [AnyLinkPreview.builder] and
  /// allows building a custom [Widget] from the [Metadata], with either of
  /// the optional [ImageProvider] or [SvgPicture] fetched.
  final Widget Function(BuildContext, Metadata, ImageProvider?, SvgPicture?)?
      itemBuilder;

  const AnyLinkPreview({
    super.key,
    required this.link,
    this.cache = const Duration(days: 1),
    this.titleStyle,
    this.bodyStyle,
    this.displayDirection = UIDirection.uiDirectionVertical,
    this.showMultimedia = true,
    this.backgroundColor = const Color.fromRGBO(235, 235, 235, 1),
    this.bodyMaxLines = 3,
    this.bodyTextOverflow = TextOverflow.ellipsis,
    this.placeholderWidget,
    this.errorWidget,
    this.errorBody,
    this.errorImage,
    this.errorTitle,
    this.borderRadius,
    this.boxShadow,
    this.removeElevation = false,
    this.proxyUrl,
    this.headers,
    this.onTap,
    this.previewHeight,
    this.urlLaunchMode = LaunchMode.platformDefault,
  }) : itemBuilder = null;

  const AnyLinkPreview.builder({
    super.key,
    required this.link,
    required this.itemBuilder,
    this.cache = const Duration(days: 1),
    this.placeholderWidget,
    this.errorWidget,
    this.proxyUrl,
    this.headers,
  })  : titleStyle = null,
        bodyStyle = null,
        displayDirection = UIDirection.uiDirectionVertical,
        showMultimedia = true,
        backgroundColor = null,
        bodyMaxLines = 3,
        bodyTextOverflow = TextOverflow.ellipsis,
        borderRadius = null,
        errorBody = null,
        errorImage = null,
        errorTitle = null,
        boxShadow = null,
        removeElevation = false,
        onTap = null,
        previewHeight = null,
        urlLaunchMode = LaunchMode.platformDefault;

  @override
  AnyLinkPreviewState createState() => AnyLinkPreviewState();

  /// Method to fetch metadata directly
  static Future<Metadata?> getMetadata({
    required String link,
    String? proxyUrl = '', // Pass for web
    Duration? cache = const Duration(days: 1),
    Map<String, String>? headers,
    String? userAgent,
  }) async {
    final linkValid = isValidLink(link);
    var proxyValid = true;
    if ((proxyUrl ?? '').isNotEmpty) proxyValid = isValidLink(proxyUrl!);
    if (linkValid && proxyValid) {
      // removing www. from the link if available
      if (link.startsWith('www.')) link = link.replaceFirst('www.', '');
      final linkToFetch = ((proxyUrl ?? '') + link).trim();
      return _getMetadata(
        linkToFetch,
        cache: cache,
        headers: headers ?? {},
        userAgent: userAgent,
      );
    } else if (!linkValid) {
      throw Exception('Invalid link');
    } else {
      throw Exception('Proxy URL is invalid. Kindly pass only if required');
    }
  }

  @protected
  static Future<Metadata?> _getMetadata(
    String link, {
    Duration? cache = const Duration(days: 1),
    Map<String, String>? headers,
    String? userAgent,
  }) async {
    try {
      var info = await LinkAnalyzer.getInfo(
        link,
        cache: cache,
        headers: headers ?? {},
        userAgent: userAgent,
      );
      if (info == null || info.hasData == false) {
        // if info is null or data is empty ,try to read URL metadata
        // client-side
        info = await LinkAnalyzer.getInfoClientSide(
          link,
          cache: cache,
          headers: headers ?? {},
          userAgent: userAgent,
        );
      }
      return info;
    } catch (error) {
      return null;
    }
  }

  /// Method to verify if the link is valid or not
  static bool isValidLink(
    String link, {
    List<String> protocols = const ['http', 'https', 'ftp'],
    List<String> hostWhitelist = const [],
    List<String> hostBlacklist = const [],
    bool requireTld = true,
    bool requireProtocol = false,
    bool allowUnderscore = false,
  }) {
    if (link.isEmpty) return false;
    final options = <String, Object>{
      'require_tld': requireTld,
      'require_protocol': requireProtocol,
      'allow_underscores': allowUnderscore,
      // 'require_port': false,
      // 'require_valid_protocol': true,
      // 'allow_trailing_dot': false,
      // 'allow_protocol_relative_urls': false,
      // 'allow_fragments': true,
      // 'allow_query_components': true,
      // 'disallow_auth': false,
      // 'validate_length': true
    };
    if (protocols.isNotEmpty) options['protocols'] = protocols;
    if (hostWhitelist.isNotEmpty) options['host_whitelist'] = hostWhitelist;
    if (hostBlacklist.isNotEmpty) options['host_blacklist'] = hostBlacklist;

    return isURL(link, options);
  }
}

class AnyLinkPreviewState extends State<AnyLinkPreview> {
  BaseMetaInfo? _info;

  late final String _errorImage;
  late final String _errorTitle;
  late final String _errorBody;
  late final String originalLink;
  late final bool _linkValid;

  bool _proxyValid = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    final providedLink = widget.link;

    _errorImage = widget.errorImage ??
        'https://github.com/sur950/any_link_preview/blob/master/lib/assets/giphy.gif?raw=true';
    _errorTitle = widget.errorTitle ?? 'Something went wrong!';
    _errorBody = widget.errorBody ??
        'Oops! Unable to parse the url. We have sent feedback to our developers'
            '& we will try to fix this in our next release. Thanks!';

    _linkValid = AnyLinkPreview.isValidLink(providedLink);

    if ((widget.proxyUrl ?? '').isNotEmpty) {
      _proxyValid = AnyLinkPreview.isValidLink(widget.proxyUrl!);
    }

    if (_linkValid && _proxyValid) {
      // removing www. from the link if it's present
      if (providedLink.startsWith('www.')) {
        originalLink = providedLink.replaceFirst('www.', '');
      } else {
        originalLink = providedLink;
      }

      final linkToFetch = ((widget.proxyUrl ?? '') + originalLink).trim();
      _loading = true;
      _getInfo(linkToFetch);
    }
  }

  Future<void> _getInfo(String link) async {
    _info = await AnyLinkPreview._getMetadata(
      link,
      cache: widget.cache,
      headers: widget.headers,
    );
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: widget.urlLaunchMode);
    } else {
      try {
        await launchUrl(uri, mode: widget.urlLaunchMode);
      } catch (err) {
        throw Exception('Could not launch $url. Error: $err');
      }
    }
  }

  Widget _buildPlaceHolder(double defaultHeight) {
    return SizedBox(
      height: defaultHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layoutWidth = constraints.biggest.width;
          final layoutHeight = constraints.biggest.height;

          return Container(
            color: widget.backgroundColor,
            width: layoutWidth,
            height: layoutHeight,
          );
        },
      ),
    );
  }

  Widget _buildLinkContainer(double height, Metadata info) {
    final image = LinkAnalyzer.isNotEmpty(info.image)
        ? ((widget.proxyUrl ?? '') + (info.image ?? ''))
        : null;

    if (widget.itemBuilder != null) {
      final imageData = buildImageProvider(image, _errorImage);
      return widget.itemBuilder!(
        context,
        info,
        imageData.image,
        imageData.svgImage,
      );
    }

    final isTitleEmpty =
        LinkAnalyzer.isEmpty(info.title) || info.title == getDomain(info.url!);
    final isDescEmpty =
        LinkAnalyzer.isEmpty(info.desc) || info.desc == info.url;
    if (isTitleEmpty && isDescEmpty && widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    final title =
        LinkAnalyzer.isNotEmpty(info.title) ? info.title! : _errorTitle;
    final desc = LinkAnalyzer.isNotEmpty(info.desc) ? info.desc! : _errorBody;
    final imageProvider = buildImageProvider(image, _errorImage);

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        boxShadow: widget.removeElevation
            ? const []
            : widget.boxShadow ??
                [const BoxShadow(blurRadius: 3, color: Colors.grey)],
      ),
      height: height,
      child: (widget.displayDirection == UIDirection.uiDirectionHorizontal)
          ? LinkViewHorizontal(
              key: widget.key ?? Key(originalLink),
              url: originalLink,
              title: title,
              description: desc,
              imageProvider: imageProvider,
              onTap: widget.onTap ?? () => _launchURL(originalLink),
              titleTextStyle: widget.titleStyle,
              bodyTextStyle: widget.bodyStyle,
              bodyTextOverflow: widget.bodyTextOverflow,
              bodyMaxLines: widget.bodyMaxLines,
              showMultiMedia: widget.showMultimedia,
              bgColor: widget.backgroundColor,
              radius: widget.borderRadius ?? 12,
            )
          : LinkViewVertical(
              key: widget.key ?? Key(originalLink),
              url: originalLink,
              title: title,
              description: desc,
              imageProvider: imageProvider,
              onTap: widget.onTap ?? () => _launchURL(originalLink),
              titleTextStyle: widget.titleStyle,
              bodyTextStyle: widget.bodyStyle,
              bodyTextOverflow: widget.bodyTextOverflow,
              bodyMaxLines: widget.bodyMaxLines,
              showMultiMedia: widget.showMultimedia,
              bgColor: widget.backgroundColor,
              radius: widget.borderRadius ?? 12,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.sizeOf(context);
    final info = _info as Metadata?;
    final height = widget.previewHeight ??
        ((widget.displayDirection == UIDirection.uiDirectionHorizontal ||
                !widget.showMultimedia)
            ? ((mediaQuerySize.height) * 0.15)
            : ((mediaQuerySize.height) * 0.25));

    final loadingErrorWidget = Container(
      height: height,
      width: mediaQuerySize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        color: Colors.grey[200],
      ),
      alignment: Alignment.center,
      child: Text(
        !_linkValid
            ? 'Invalid Link'
            : !_proxyValid
                ? 'Proxy URL is invalid. Kindly pass only if required'
                : 'Fetching data...',
      ),
    );

    if (_loading) {
      return (!_linkValid || !_proxyValid)
          ? loadingErrorWidget
          : (widget.placeholderWidget ?? loadingErrorWidget);
    }

    return info == null
        ? widget.errorWidget ?? _buildPlaceHolder(height)
        : _buildLinkContainer(height, info);
  }
}
