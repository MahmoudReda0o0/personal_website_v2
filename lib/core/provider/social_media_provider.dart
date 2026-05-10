import 'package:flutter/material.dart';
import 'package:personal_website_v2/core/firebase/firebase_service.dart';
import 'package:personal_website_v2/core/model/social_media.dart';

class SocialMediaProvider extends ChangeNotifier {
  List<SocialMedia> socialData = <SocialMedia>[];
  fetchSocialData() async {
    socialData = await FirebaseService().getSocialMedia();
    notifyListeners();
  }
}
