# Any_link_preview

<p align="center">
  <img width="460"  src="https://github.com/sur950/any_link_preview/blob/master/demo_images/main.jpg">
</p>

[![Pub](https://img.shields.io/pub/v/any_link_preview.svg)](https://pub.dartlang.org/packages/any_link_preview)
[![Build Status](https://travis-ci.org/sur950/any_link_preview.svg?branch=master)](https://travis-ci.org/sur950/any_link_preview)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/suresh950?locale.x=en_GB)

A flutter package/plugin which will help you to show preview of the web url's with beautiful & completely customizable design. Can be useful for Chat application 🤓🤓

## Features 💚

- In android, uses native jsoup to fetch meta data
- In All other platforms, uses web parser to fetch meta data
- Highly customizable
- Placeholder which can be used while the state is in loading.
- Error widget which can be used when unidentified error are detected
- For identified erros, one can customize by passing custom title, description & image.
- Opt-in/Opt-out for media (images, icons etc) to be displayed in UI or not
- multiple directions are supported (Horizontal, Vertical)
- Cache the meta data of an url for faster load
- Checkout the example app for usage

## Getting Started ⚡️

#### Demo

<img src="https://github.com/sur950/any_link_preview/blob/master/demo_images/demo.jpg" width="240" height="480">


## Notes

- IOS developers who can help me in implementing native methods for fetching meta data are most welcome, which might give us promising results for all sort of public url's.
- Do you have any suggestions in improving the Package/Plugin? I really love to do this kind of stuff. Do contact me via Homepage link.
- If you use have used it in your application, drop a smile & your app link to me, I will be adding those to the same page.

## Properties 🔖

```Dart
  final Key key;

  /// Display direction. One among `UIDirectionVertical, UIDirectionHorizontal`
  /// By default it is `UIDirectionVertical`
  final UIDirection displayDirection;

  /// Web address (Url that need to be parsed)
  /// For IOS & Web, only HTTP and HTTPS are support
  /// For Android, all url's are supported
  final String link;

  /// Customize background colour
  /// Deaults to `Color.fromRGBO(235, 235, 235, 1)`
  final Color backgroundColor;

  /// Widget that need to be shown when
  /// plugin is trying to fetch metadata
  /// If not given anything then default one will be shown
  final Widget placeholderWidget;

  /// Widget that need to be shown if something goes wrong
  /// Defaults to plain container with given background colour
  /// If the issue is know then we will show customized UI
  /// Other options of error params are used
  final Widget errorWidget;

  /// Title that need to be shown if something goes wrong
  /// Deaults to `Something went wrong!`
  final String errorTitle;

  /// Body that need to be shown if something goes wrong
  /// Deaults to `Oops! Unable to parse the url. We have sent feedback to our developers & we will try to fix this in our next release. Thanks!`
  final String errorBody;

  /// Image that will be shown if something goes wrong
  /// & when multimedia enabled & no meta data is available
  /// Deaults to `A semi-soccer ball image that looks like crying`
  final String errorImage;

  /// Give the overflow type for body text (Description)
  /// Deaults to `TextOverflow.ellipsis`
  final TextOverflow bodyTextOverflow;

  /// Give the limit to body text (Description)
  /// Deaults to `3`
  final int bodyMaxLines;

  /// Cache result time, default cache `30 days`
  /// Works only for IOS & not for android
  final Duration cache;

  /// Customize body `TextStyle`
  final TextStyle titleStyle;

  /// Customize body `TextStyle`
  final TextStyle bodyStyle;

  /// Show or Hide image if available defaults to `true`
  final bool showMultimedia;

```

## Active Apps which use the plugin ✨

Thanks to everyone whoever suggested their thoughts to improve this package. And special thanks goes to these apps who used the plugin & given continous feedback to improve the package:

<table>
  <tr>
    <td align="center"><a href="https://www.chant.fan/"><img src="https://github.com/sur950/any_link_preview/blob/master/demo_images/chant.png" width="100px;" alt="Chant LLC"/><br /><sub><b>Chant</b></sub></a></td>
    <td align="center"><a href="https://vardaan.app/"><img src="https://github.com/sur950/any_link_preview/blob/master/demo_images/vardaan.png" width="100px;" alt="Vardaan"/><br /><sub><b>Vardaan</b></sub></a></td>
    <td align="center"><a href="https://myflat.io/"><img src="https://github.com/sur950/any_link_preview/blob/master/demo_images/myFlat.png" width="100px;" alt="myFlat"/><br /><sub><b>myFlat</b></sub></a></td>
  </tr>
</table>

**The pin code text field widget example**

```Dart
AnyLinkPreview(
    link: "https://vardaan.app/",
    displayDirection: UIDirection.UIDirectionHorizontal,
    showMultimedia: false,
    bodyMaxLines: 5,
    bodyTextOverflow: TextOverflow.ellipsis,
    titleStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 15,
    ),
    bodyStyle: TextStyle(color: Colors.grey, fontSize: 12),
    errorBody: 'Show my custom error body',
    errorTitle: 'Show my custom error title',
    errorWidget: Container(
        color: Colors.grey[300],
        child: Text('Oops!'),
    ),
    errorImage: "https://google.com/",
    cache: Duration(days: 7),
    backgroundColor: Colors.grey[300]
)
```

**displayDirection can be among these 2 types**

```Dart
enum UIDirection { UIDirectionHorizontal, UIDirectionVertical }
```

**This full code is from the example folder. You can run the example to see.**

```Dart
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// I picked these links & images from internet
  final String _errorImage =
      "https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg";
  final String _url1 =
      "https://www.espn.in/football/soccer-transfers/story/4163866/transfer-talk-lionel-messi-tells-barcelona-hes-more-likely-to-leave-then-stay";
  final String _url2 =
      "https://speakerdeck.com/themsaid/the-power-of-laravel-queues";
  final String _url3 =
      "https://twitter.com/laravelphp/status/1222535498880692225";
  final String _url4 = "https://www.youtube.com/watch?v=W1pNjxmNHNQ";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Any Link Preview')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnyLinkPreview(
                link: _url1,
                displayDirection: UIDirection.UIDirectionHorizontal,
                cache: Duration(hours: 1),
                backgroundColor: Colors.grey[300],
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: Text('Oops!'),
                ),
                errorImage: _errorImage,
              ),
              SizedBox(height: 25),
              AnyLinkPreview(
                link: _url2,
                displayDirection: UIDirection.UIDirectionHorizontal,
                showMultimedia: false,
                bodyMaxLines: 5,
                bodyTextOverflow: TextOverflow.ellipsis,
                titleStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                bodyStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(height: 25),
              AnyLinkPreview(
                displayDirection: UIDirection.UIDirectionHorizontal,
                link: _url3,
                errorBody: 'Show my custom error body',
                errorTitle: 'Show my custom error title',
              ),
              SizedBox(height: 25),
              AnyLinkPreview(link: _url4),
            ],
          ),
        ),
      ),
    );
  }
}

```
