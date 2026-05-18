import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:personal_website_v2/core/firebase/firebase_service.dart';
import 'package:personal_website_v2/core/model/setting_model.dart';
import 'package:personal_website_v2/core/model/social_media.dart';

class AppProvider extends ChangeNotifier {
  List<SocialMedia> socialData = <SocialMedia>[];
  SettingModel setting = SettingModel.defaultSetting();
  fetchInitialData() async {
    await fetchSettingData();
    await fetchSocialData();
  }

  fetchSocialData() async {
    socialData = await FirebaseService().getSocialMedia();
    notifyListeners();
  }

  fetchSettingData() async {
    setting = await FirebaseService().getSetting();
    notifyListeners();
  }

  updateSettingData() async {
    bool result = await FirebaseService().updateSettingData(setting);
    if (result) {
      await fetchInitialData();
    } else {
      log(name: 'sdochdsoc', 'error');
    }
  }

  changeSocialSetting(bool value) async {
    setting.showSocialMedial = value;
    notifyListeners();
  }

  changeProjectSetting(bool value) async {
    setting.showProjects = value;
    notifyListeners();
  }
}
