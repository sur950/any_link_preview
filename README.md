# Any_link_preview

<p align="center">
  <img width="460"  src="https://github.com/sur950/any_link_preview/blob/master/demo_images/main.jpg?raw=true">
</p>

[![Pub](https://img.shields.io/pub/v/any_link_preview.svg)](https://pub.dartlang.org/packages/any_link_preview)
[![Build Status](https://travis-ci.org/sur950/any_link_preview.svg?branch=master)](https://travis-ci.org/sur950/any_link_preview)
[![License](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/suresh950?locale.x=en_GB)

A flutter package which will help you to show preview of the web url's with beautiful & completely customizable design. Can be useful for Chat application 🤓🤓

## Features 💚

- Uses 4 different types of parser's to fetch meta data
- HTML Parser, JSON LD Parser, Open Graph Parser, Twitter Cards Parser and more coming up in the future.
- Highly customizable
- Placeholder which can be used while the state is in loading.
- Error widget which can be used when unidentified error are detected
- For identified errors, one can customize by passing custom title, description & image.
- Opt-in/Opt-out for media (images, icons etc) to be displayed in UI or not
- multiple directions are supported (Horizontal, Vertical)
- Cache the meta data of an url for faster load
- Checkout the example app for usage

## Getting Started ⚡️

#### Demo

<img src="https://github.com/sur950/any_link_preview/blob/master/demo_images/demo.jpg?raw=true" width="240" height="480">

## Notes

- Do you have any suggestions in improving the Package? I really love to collaborate. Do contact me <a href="https://www.linkedin.com/public-profile/in/suresh-konakanchi-b47602117">here</a>.
- If you have used this package in your application & saved your dev time then feel free to buy me a coffee by clicking <a href="https://paypal.me/suresh950?locale.x=en_GB">here</a>.
- This package is open for contribution(s).
- <span style="color:skyblue;">Can be used as a Widget or as a Method(function)</span>
- Call <span style="color:blue;">AnyLinkPreview.isValidLink()</span> method to check if the link is valid or not (Strongly suggested to call it before using it in Widget).

## <span style="color:orange;">⭐ Don't forgot to Star the repo</span>

## How to Contribute?

1. Fork it
2. Create your fix/feature branch (`git checkout -b my-branch`)
3. Commit your changes (`git commit -am 'Added some feature/fix'`)
4. Push to the branch (`git push origin my-branch`)
5. Create Pull Request

## Properties 🔖

```Dart
  /// Display direction. One among `uiDirectionVertical, uiDirectionHorizontal`
  /// By default it is `uiDirectionVertical`
  final UIDirection displayDirection;

  /// Parameter to choose how you'd like the app to handle the link
  /// Default is `LaunchMode.platformDefault`
  final LaunchMode urlLaunchMode;

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

  /// Headers to be added in the HTTP request to the link
  final Map<String, String>? headers;

  /// Function that needs to be called when user taps on the card.
  /// If not given then given URL will be launched.
  /// To disable, Pass empty function.
  final void Function()? onTap;

  /// Height of the preview card. Defaults to
  /// `(MediaQuery.of(context).size.height) * 0.15` in case of horizontal and
  /// `(MediaQuery.of(context).size.height) * 0.25` in case of vertical
  final double? previewHeight;

  /// Function only in [AnyLinkPreview.builder]
  /// allows to build a custom [Widget] from the [Metadata] and [ImageProvider] fetched
  final Widget Function(BuildContext, Metadata, ImageProvider?)? itemBuilder;

```

## Special Thanks ✨

Thanks to all the contributors

<a href = "https://github.com/sur950/any_link_preview/graphs/contributors">
  <img src = "https://contrib.rocks/image?repo=sur950/any_link_preview"/>
</a>
<br />

**The AnyLinkPreview widget example**

```Dart
AnyLinkPreview(
    link: "https://vardaan.app/",
    displayDirection: UIDirection.uiDirectionHorizontal,
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
    backgroundColor: Colors.grey[300],
    borderRadius: 12,
    removeElevation: false,
    boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)];
    onTap: (){}, // This disables tap event
)
```

**The AnyLinkPreview method/function example**

```Dart
// We will use this to build our own custom UI
Metadata? _metadata = await AnyLinkPreview.getMetadata(
  link: "https://google.com/",
  cache: Duration(days: 7),
  proxyUrl: "https://cors-anywhere.herokuapp.com/", // Need for web
);
print(_metadata?.title);
```

**Method to validate the link example**

```Dart
// Method to check if the url is valid or not before passing to the previewer
bool _isUrlValid = AnyLinkPreview.isValidLink(
  "https://google.com/",
  protocols: ['http', 'https'],
  hostWhitelist: ['https://youtube.com/'],
  hostBlacklist: ['https://facebook.com/'],
);
print('_isUrlValid => $_isUrlValid');
```

**displayDirection can be among these 2 types**

```Dart
enum UIDirection { uiDirectionVertical, uiDirectionHorizontal }
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
  final String _url5 = "https://www.brainyquote.com/topics/motivational-quotes";

  @override
  void initState() {
    super.initState();
    _getMetadata(_url5);
  }

  void _getMetadata(String url) async {
    bool _isValid = _getUrlValid(url);
    if (_isValid) {
      Metadata? _metadata = await AnyLinkPreview.getMetadata(
        link: url,
        cache: Duration(days: 7),
        proxyUrl: "https://cors-anywhere.herokuapp.com/", // Needed for web app
      );
      debugPrint(_metadata?.title);
      debugPrint(_metadata?.desc);
    } else {
      debugPrint("URL is not valid");
    }
  }

  bool _getUrlValid(String url) {
    bool _isUrlValid = AnyLinkPreview.isValidLink(
      url,
      protocols: ['http', 'https'],
      hostWhitelist: ['https://youtube.com/'],
      hostBlacklist: ['https://facebook.com/'],
    );
    return _isUrlValid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Any Link Preview')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnyLinkPreview(
                link: _url1,
                displayDirection: UIDirection.uiDirectionHorizontal,
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
                displayDirection: UIDirection.uiDirectionHorizontal,
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
                displayDirection: UIDirection.uiDirectionHorizontal,
                link: _url3,
                errorBody: 'Show my custom error body',
                errorTitle: 'Next one is youtube link, error title',
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

### License

```

Copyright (c) 2022 Konakanchi Venkata Suresh Babu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

```
