import 'dart:async';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'link_analyzer.dart';
import '../widgets/link_view_horizontal.dart';
import '../widgets/link_view_vertical.dart';

enum uiDirection { uiDirectionVertical, uiDirectionHorizontal }

class AnyLinkPreview extends StatefulWidget {
  /// Display direction. One among `uiDirectionVertical, uiDirectionHorizontal`
  /// By default it is `uiDirectionVertical`
  final uiDirection displayDirection;

  /// Web address (Url that need to be parsed)
  /// For IOS & Web, only HTTP and HTTPS are support
  /// For Android, all url's are supported
  final String link;

  /// Customize background colour
  /// Deaults to `Color.fromRGBO(235, 235, 235, 1)`
  final Color? backgroundColor;

  /// Widget that need to be shown when
  /// plugin is trying to fetch metadata
  /// If not given anything then default one will be shown
  final Widget? placeholderWidget;

  /// Widget that need to be shown if something goes wrong
  /// Defaults to plain container with given background colour
  /// If the issue is know then we will show customized UI
  /// Other options of error params are used
  final Widget? errorWidget;

  /// Title that need to be shown if something goes wrong
  /// Deaults to `Something went wrong!`
  final String? errorTitle;

  /// Body that need to be shown if something goes wrong
  /// Deaults to `Oops! Unable to parse the url. We have sent feedback to our developers & we will try to fix this in our next release. Thanks!`
  final String? errorBody;

  /// Image that will be shown if something goes wrong
  /// & when multimedia enabled & no meta data is available
  /// Deaults to `A semi-soccer ball image that looks like crying`
  final String? errorImage;

  /// Give the overflow type for body text (Description)
  /// Deaults to `TextOverflow.ellipsis`
  final TextOverflow bodyTextOverflow;

  /// Give the limit to body text (Description)
  /// Deaults to `3`
  final int bodyMaxLines;

  /// Cache result time, default cache `1 day`
  /// Pass null to disable
  final Duration cache;

  /// Customize body `TextStyle`
  final TextStyle? titleStyle;

  /// Customize body `TextStyle`
  final TextStyle? bodyStyle;

  /// Show or Hide image if available defaults to `true`
  final bool showMultimedia;

  /// BorderRadius for the card. Deafults to `12`
  final double? borderRadius;

  /// To remove the card elevation set it to `true`
  /// Default value is `false`
  final bool removeElevation;

  /// Box shadow for the card. Deafults to `[BoxShadow(blurRadius: 3, color: Colors.grey)]`
  final List<BoxShadow>? boxShadow;

  /// Proxy URL to pass that resolve CORS issues on web.
  /// For example, `https://cors-anywhere.herokuapp.com/` .
  final String? proxyUrl;

  /// Function that needs to be called when user taps on the card.
  /// If not given then given URL will be launched.
  /// To disable, Pass empty function.
  final void Function()? onTap;

  AnyLinkPreview({
    Key? key,
    required this.link,
    this.cache = const Duration(days: 1),
    this.titleStyle,
    this.bodyStyle,
    this.displayDirection = uiDirection.uiDirectionVertical,
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
    this.onTap,
  }) : super(key: key);

  @override
  _AnyLinkPreviewState createState() => _AnyLinkPreviewState();

  /// Method to fetch metadata directly
  static FutureOr<Metadata?> getMetadata({
    required String link,
    String? proxyUrl = '', // Pass for web
    Duration? cache = const Duration(days: 1),
  }) async {
    var _linkValid = isValidLink(link);
    var _proxyValid = true;
    if ((proxyUrl ?? '').isNotEmpty) _proxyValid = isValidLink(proxyUrl!);
    if (_linkValid && _proxyValid) {
      var _linkToFetch = ((proxyUrl ?? '') + link).trim();
      var _info = await LinkAnalyzer.getInfo(_linkToFetch, cache: cache);
      return _info;
    } else if (!_linkValid) {
      throw Exception('Invalid link');
    } else if (!_proxyValid) {
      throw Exception('Proxy URL is invalid. Kindly pass only if required');
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
    Map<String, Object>? _options = {
      'require_tld': requireTld,
      'requireProtocol': requireProtocol,
      'allowUnderscore': allowUnderscore,
    };
    if (protocols.isNotEmpty) _options['protocols'] = protocols;
    if (hostWhitelist.isNotEmpty) _options['hostWhitelist'] = hostWhitelist;
    if (hostBlacklist.isNotEmpty) _options['hostBlacklist'] = hostBlacklist;
    var _isValid = isURL(link, _options);
    return _isValid;
  }
}

class _AnyLinkPreviewState extends State<AnyLinkPreview> {
  BaseMetaInfo? _info;
  String? _errorImage, _errorTitle, _errorBody;
  bool _loading = false;
  bool _linkValid = false, _proxyValid = true;

  @override
  void initState() {
    _errorImage = widget.errorImage ??
        'https://github.com/sur950/any_link_preview/blob/master/lib/assets/giphy.gif?raw=true';
    _errorTitle = widget.errorTitle ?? 'Something went wrong!';
    _errorBody = widget.errorBody ??
        'Oops! Unable to parse the url. We have sent feedback to our developers & we will try to fix this in our next release. Thanks!';

    _linkValid = AnyLinkPreview.isValidLink(widget.link);
    if ((widget.proxyUrl ?? '').isNotEmpty) {
      _proxyValid = AnyLinkPreview.isValidLink(widget.proxyUrl!);
    }
    if (_linkValid && _proxyValid) {
      var _linkToFetch = ((widget.proxyUrl ?? '') + widget.link).trim();
      _loading = true;
      _getInfo(_linkToFetch);
    }
    super.initState();
  }

  Future<void> _getInfo(String link) async {
    _info = await LinkAnalyzer.getInfo(link, cache: widget.cache);
    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      try {
        await launch(url);
      } catch (err) {
        throw Exception('Could not launch $url. Error: $err');
      }
    }
  }

  Widget _buildPlaceHolder(Color color, double defaultHeight) {
    return Container(
      height: defaultHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        var layoutWidth = constraints.biggest.width;
        var layoutHeight = constraints.biggest.height;

        return Container(
          color: color,
          width: layoutWidth,
          height: layoutHeight,
        );
      }),
    );
  }

  Widget _buildLinkContainer(
    double _height, {
    String? title = '',
    String? desc = '',
    String? image = '',
  }) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        boxShadow: widget.removeElevation
            ? []
            : widget.boxShadow ??
                [BoxShadow(blurRadius: 3, color: Colors.grey)],
      ),
      height: _height,
      child: (widget.displayDirection == uiDirection.uiDirectionHorizontal)
          ? LinkViewHorizontal(
              key: widget.key ?? Key(widget.link.toString()),
              url: widget.link,
              title: title!,
              description: desc!,
              imageUri: image!,
              onTap: widget.onTap ?? () => _launchURL(widget.link),
              titleTextStyle: widget.titleStyle,
              bodyTextStyle: widget.bodyStyle,
              bodyTextOverflow: widget.bodyTextOverflow,
              bodyMaxLines: widget.bodyMaxLines,
              showMultiMedia: widget.showMultimedia,
              bgColor: widget.backgroundColor,
              radius: widget.borderRadius ?? 12,
            )
          : LinkViewVertical(
              key: widget.key ?? Key(widget.link.toString()),
              url: widget.link,
              title: title!,
              description: desc!,
              imageUri: image!,
              onTap: widget.onTap ?? () => _launchURL(widget.link),
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
    final info = _info as Metadata?;
    var _height =
        (widget.displayDirection == uiDirection.uiDirectionHorizontal ||
                !widget.showMultimedia)
            ? ((MediaQuery.of(context).size.height) * 0.15)
            : ((MediaQuery.of(context).size.height) * 0.25);

    Widget _loadingErrorWidget = Container(
      height: _height,
      width: MediaQuery.of(context).size.width,
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
          ? _loadingErrorWidget
          : (widget.placeholderWidget ?? _loadingErrorWidget);
    }

    return _info == null
        ? widget.errorWidget ??
            _buildPlaceHolder(widget.backgroundColor!, _height)
        : _buildLinkContainer(
            _height,
            title:
                LinkAnalyzer.isNotEmpty(info!.title) ? info.title : _errorTitle,
            desc: LinkAnalyzer.isNotEmpty(info.desc) ? info.desc : _errorBody,
            image: LinkAnalyzer.isNotEmpty(info.image)
                ? ((widget.proxyUrl ?? '') + (info.image ?? ''))
                : _errorImage,
          );
  }
}
