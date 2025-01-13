import 'package:any_link_preview/src/utilities/image_provider.dart';
import 'package:flutter/material.dart';

class LinkViewVertical extends StatelessWidget {
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

  const LinkViewVertical({
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
    this.bodyPadding,
    this.titlePadding,
    super.key,
  });

  double computeTitleFontSize(double width) {
    final size = width * 0.13;
    return size > 15 ? 15 : size;
  }

  int computeTitleLines(double layoutHeight, double layoutWidth) {
    return (layoutHeight - layoutWidth < 50) ? 1 : 2;
  }

  int? computeBodyLines(double layoutHeight) {
    final bodyLines = layoutHeight ~/ 60;
    return bodyLines == 0 ? 1 : bodyLines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutWidth = constraints.biggest.width;
        final layoutHeight = constraints.biggest.height;

        final titleStyle_ = titleTextStyle ??
            TextStyle(
              fontSize: computeTitleFontSize(layoutHeight),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            );
        final bodyStyle_ = bodyTextStyle ??
            TextStyle(
              fontSize: computeTitleFontSize(layoutHeight) - 1,
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
          child: Column(
            children: [
              if (showMultiMedia)
                Expanded(
                  flex: 2,
                  child: imageProvider.image == null &&
                          imageProvider.svgImage == null
                      ? Container(color: bgColor ?? Colors.grey)
                      : Container(
                          padding: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: radius == 0
                                ? BorderRadius.zero
                                : BorderRadius.vertical(
                                    top: Radius.circular(radius!),
                                  ),
                            image: imageProvider.image != null
                                ? DecorationImage(
                                    image: imageProvider.image!,
                                    fit: BoxFit.fitWidth,
                                  )
                                : null,
                          ),
                          child: imageProvider.svgImage,
                        ),
                )
              else
                const SizedBox(height: 5),
              _buildTitleContainer(
                titleStyle_,
                computeTitleLines(layoutHeight, layoutWidth),
              ),
              _buildBodyContainer(
                bodyStyle_,
                computeBodyLines(layoutHeight),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleContainer(TextStyle titleStyle, int? maxLines) {
    return Padding(
      padding: titlePadding ?? const EdgeInsets.fromLTRB(10, 5, 5, 1),
      child: Container(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: titleStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle bodyStyle, int? maxLines) {
    return Expanded(
      child: Padding(
        padding: bodyPadding ?? const EdgeInsets.fromLTRB(10, 0, 5, 5),
        child: Container(
          alignment: Alignment.topLeft,
          child: Text(
            description,
            style: bodyStyle,
            overflow: bodyTextOverflow ?? TextOverflow.ellipsis,
            maxLines: bodyMaxLines ?? maxLines,
          ),
        ),
      ),
    );
  }
}
