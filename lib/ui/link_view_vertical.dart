import 'package:flutter/material.dart';

class LinkViewVertical extends StatelessWidget {
  final String url;
  final String title;
  final String description;
  final String imageUri;
  final Function(String) onTap;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final bool? showMultiMedia;
  final TextOverflow? bodyTextOverflow;
  final int? bodyMaxLines;
  final bool isIcon;
  final double? radius;
  final Color? bgColor;

  LinkViewVertical({
    Key? key,
    required this.url,
    required this.title,
    required this.description,
    required this.imageUri,
    required this.onTap,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.showMultiMedia,
    this.bodyTextOverflow,
    this.bodyMaxLines,
    this.isIcon = false,
    this.bgColor,
    this.radius,
  }) : super(key: key);

  double computeTitleFontSize(double height) {
    double size = height * 0.13;
    if (size > 15) {
      size = 15;
    }
    return size;
  }

  int computeTitleLines(layoutHeight, layoutWidth) {
    return layoutHeight - layoutWidth < 50 ? 1 : 2;
  }

  int? computeBodyLines(layoutHeight) {
    return layoutHeight ~/ 60 == 0 ? 1 : layoutHeight ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var layoutWidth = constraints.biggest.width;
      var layoutHeight = constraints.biggest.height;

      var _titleTS = titleTextStyle ??
          TextStyle(
            fontSize: computeTitleFontSize(layoutHeight),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          );
      var _bodyTS = bodyTextStyle ??
          TextStyle(
            fontSize: computeTitleFontSize(layoutHeight) - 1,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          );

      return InkWell(
          onTap: () => onTap(url),
          child: Column(
            children: <Widget>[
              showMultiMedia!
                  ? Expanded(
                      flex: 2,
                      child: imageUri == ""
                          ? Container(color: bgColor ?? Colors.grey)
                          : Container(
                              padding: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                borderRadius: radius == 0
                                    ? BorderRadius.zero
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                image: DecorationImage(
                                  image: NetworkImage(imageUri),
                                  fit:
                                      isIcon ? BoxFit.contain : BoxFit.fitWidth,
                                ),
                              ),
                            ),
                    )
                  : SizedBox(height: 5),
              _buildTitleContainer(
                  _titleTS, computeTitleLines(layoutHeight, layoutWidth)),
              _buildBodyContainer(_bodyTS, computeBodyLines(layoutHeight)),
            ],
          ));
    });
  }

  Widget _buildTitleContainer(TextStyle _titleTS, _maxLines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 1),
      child: Container(
        alignment: Alignment(-1.0, -1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: _titleTS,
              overflow: TextOverflow.ellipsis,
              maxLines: _maxLines,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle _bodyTS, _maxLines) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 5, 5),
        child: Container(
          alignment: Alignment(-1.0, -1.0),
          child: Text(
            description,
            style: _bodyTS,
            overflow: bodyTextOverflow == null
                ? TextOverflow.ellipsis
                : bodyTextOverflow,
            maxLines: bodyMaxLines == null ? _maxLines : bodyMaxLines,
          ),
        ),
      ),
    );
  }
}
