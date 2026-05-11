import 'package:flutter/material.dart';
import 'package:personal_website_v2/core/firebase/firebase_service.dart';
import 'package:personal_website_v2/core/model/setting_model.dart';
import 'package:personal_website_v2/core/model/social_media.dart';

class AppProvider extends ChangeNotifier {
  List<SocialMedia> socialData = <SocialMedia>[];
  SettingModel setting = SettingModel.defaultSetting();
  fetchSocialData() async {
    socialData = await FirebaseService().getSocialMedia();
    notifyListeners();
  }

  fetchSettingData() async {
    setting = await FirebaseService().getSetting();
    notifyListeners();
  }
}
