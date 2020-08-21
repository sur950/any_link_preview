package com.example.any_link_preview;

import androidx.annotation.NonNull;

import android.webkit.URLUtil;
import android.os.Handler;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AnyLinkPreviewPlugin */
public class AnyLinkPreviewPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;
  final private Handler mainHandler = new Handler();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "any_link_preview");
    channel.setMethodCallHandler(this);
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "any_link_preview");
    channel.setMethodCallHandler(new AnyLinkPreviewPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("metaData")){
      handleUrlMetaData(call, result);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void handleUrlMetaData(MethodCall call, final Result result) {
    @SuppressWarnings("unchecked")
    Map<String, Object> arguments = (Map<String, Object>) call.arguments;
    final String url = (String) arguments.get("url");
    new Thread(new Runnable() {
      @Override
      public void run() {
        final MetaData metaData = new MetaData();
        try {
          Document doc = Jsoup.connect(url).timeout(5 * 1000).get();
          Elements elements = doc.getElementsByTag("meta");
          // getTitle doc.select("meta[property=og:title]")
          String title = doc.select("meta[property=og:title]").attr("content");
          if (title == null || title.isEmpty()) {
            title = doc.title();
          }
          metaData.setTitle(title);

          // getDescription
          String description = doc.select("meta[name=description]").attr("content");
          if (description.isEmpty() || description == null) {
            description = doc.select("meta[name=Description]").attr("content");
          }
          if (description.isEmpty() || description == null) {
            description = doc.select("meta[property=og:description]").attr("content");
          }
          if (description.isEmpty() || description == null) {
            description = "";
          }
          metaData.setDescription(description);

          // getMediaType
          Elements mediaTypes = doc.select("meta[name=medium]");
          String type = "";
          if (mediaTypes.size() > 0) {
            String media = mediaTypes.attr("content");
            type = media.equals("image") ? "photo" : media;
          } else {
            type = doc.select("meta[property=og:type]").attr("content");
          }
          metaData.setMediatype(type);

          // getImages
          Elements imageElements = doc.select("meta[property=og:image]");
          if (imageElements.size() > 0) {
            String image = imageElements.attr("content");
            if (!image.isEmpty()) {
              metaData.setImageurl(resolveURL(url, image));
            }
          }
          if (metaData.getImageurl() == null || metaData.getImageurl().isEmpty()) {
            String src = doc.select("link[rel=image_src]").attr("href");
            if (!src.isEmpty()) {
              metaData.setImageurl(resolveURL(url, src));
            } else {
              src = doc.select("link[rel=apple-touch-icon]").attr("href");
              if (!src.isEmpty()) {
                metaData.setImageurl(resolveURL(url, src));
                metaData.setFavicon(resolveURL(url, src));
              } else {
                src = doc.select("link[rel=icon]").attr("href");
                if (!src.isEmpty()) {
                  metaData.setImageurl(resolveURL(url, src));
                  metaData.setFavicon(resolveURL(url, src));
                }
              }
            }
          }
          // Favicon
          String src = doc.select("link[rel=apple-touch-icon]").attr("href");
          if (!src.isEmpty()) {
            metaData.setFavicon(resolveURL(url, src));
          } else {
            src = doc.select("link[rel=icon]").attr("href");
            if (!src.isEmpty()) {
              metaData.setFavicon(resolveURL(url, src));
            }
          }
          for (Element element : elements) {
            if (element.hasAttr("property")) {
              String str_property = element.attr("property").toString().trim();
              if (str_property.equals("og:url")) {
                metaData.setUrl(element.attr("content").toString());
              }
              if (str_property.equals("og:site_name")) {
                metaData.setWebsiteName(element.attr("content").toString());
              }
            }
          }
          if (metaData.getUrl() == null || (metaData.getUrl().equals("") || metaData.getUrl().isEmpty())) {
            URI uri = null;
            try {
              uri = new URI(url);
              if (url == null) {
                metaData.setUrl(url);
              } else {
                metaData.setUrl(uri.getHost());
              }
            } catch (URISyntaxException e) {
              e.printStackTrace();
            }
          }
        } catch (IOException e) {
          e.printStackTrace();
        }
        mainHandler.post(new Runnable() {
          @Override
          public void run() {
            result.success(metaData.toJSON());
          }
        });
      }
    }).start();
  }

  private String resolveURL(String url, String part) {
    if (URLUtil.isValidUrl(part)) {
      return part;
    } else {
      URI base_uri = null;
      try {
        base_uri = new URI(url);
      } catch (URISyntaxException e) {
        e.printStackTrace();
      }
      base_uri = base_uri.resolve(part);
      return base_uri.toString();
    }
  }
}
