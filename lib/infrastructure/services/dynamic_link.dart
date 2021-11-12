import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink {
  ///Build a dynamic link firebase
  static Future<String> buildDynamicLink() async {
    String url = "https://yeanay.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/post/56'),
      androidParameters: AndroidParameters(
        packageName: "app.yeanay",
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: "app.yeanay",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(description: "Once upon a time in the town", imageUrl: Uri.parse("https://flutter.dev/images/flutter-logo-sharing.png"), title: "Breaking Code's Post"),
    );
    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }

  ///Retreive dynamic link firebase.
  static Future<String> initDynamicLinks() async {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      return handleDynamicLink(deepLink);
    }
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        return handleDynamicLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      return '';
    });
    return '';
  }

  static String handleDynamicLink(Uri url) {
    List<String> separatedString = [];
    separatedString.addAll(url.path.split('/'));

    return separatedString[2];
  }
}
