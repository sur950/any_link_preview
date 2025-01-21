import 'package:any_link_preview/src/utilities/image_provider.dart';
import 'package:flutter/material.dart';

class LinkViewHorizontal extends StatelessWidget {
  final String url;
  final String title;
  final String description;
  final ImageProviderValue imageProvider;
  final VoidCallback onTap;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final bool showMultiMedia;
  final TextOverflow? bodyTextOverflow;
  final int? bodyMaxLines;
  final double? radius;
  final Color? bgColor;
  final EdgeInsets? bodyPadding;
  final EdgeInsets? titlePadding;

  const LinkViewHorizontal({
    required this.url,
    required this.title,
    required this.description,
    required this.imageProvider,
    required this.onTap,
    this.showMultiMedia = true,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.bodyTextOverflow,
    this.bodyMaxLines,
    this.bgColor,
    this.radius,
    this.titlePadding,
    this.bodyPadding,
    super.key,
  });

  double computeTitleFontSize(double width) {
    final size = width * 0.13;
    return size > 15 ? 15 : size;
  }

  int computeTitleLines(double layoutHeight) {
    return layoutHeight >= 100 ? 2 : 1;
  }

  int computeBodyLines(double layoutHeight) {
    var lines = 1;
    if (layoutHeight > 40) {
      lines += (layoutHeight - 40.0) ~/ 15.0;
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutWidth = constraints.biggest.width;
        final layoutHeight = constraints.biggest.height;
        final computedFontSize = computeTitleFontSize(layoutWidth);

        final titleStyle_ = titleTextStyle ??
            TextStyle(
              fontSize: computedFontSize,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            );
        final bodyStyle_ = bodyTextStyle ??
            TextStyle(
              fontSize: computedFontSize - 1,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            );
        final cardBorderRadius = radius == 0
            ? BorderRadius.zero
            : BorderRadius.circular(
                radius!,
              );

        return InkWell(
          onTap: onTap,
          borderRadius: cardBorderRadius,
          child: Row(
            children: [
              if (showMultiMedia)
                Expanded(
                  flex: 2,
                  child: imageProvider.image == null &&
                          imageProvider.svgImage == null
                      ? Container(
                          color: bgColor ?? Colors.grey,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            image: imageProvider.image != null
                                ? DecorationImage(
                                    image: imageProvider.image!,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            borderRadius: radius == 0
                                ? BorderRadius.zero
                                : BorderRadius.horizontal(
                                    left: Radius.circular(radius!),
                                  ),
                          ),
                          child: imageProvider.svgImage ?? Container(),
                        ),
                )
              else
                const SizedBox(width: 5),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTitleContainer(
                        titleStyle_,
                        computeTitleLines(layoutHeight),
                      ),
                      _buildBodyContainer(
                        bodyStyle_,
                        computeBodyLines(layoutHeight),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleContainer(TextStyle titleStyle, int? maxLines) {
    return Padding(
      padding: titlePadding ?? const EdgeInsets.fromLTRB(4, 2, 3, 1),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: titleStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle bodyStyle, int? maxLines) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: bodyPadding ?? const EdgeInsets.fromLTRB(5, 3, 5, 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: bodyStyle,
                  overflow: bodyTextOverflow ?? TextOverflow.ellipsis,
                  maxLines: bodyMaxLines ?? maxLines,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
