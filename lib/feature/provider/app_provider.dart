import 'package:flutter/material.dart';
import 'package:personal_website_v2/core/model/personal_info.dart';
import 'package:personal_website_v2/core/model/setting_model.dart';
import 'package:personal_website_v2/core/model/social_media.dart';
import 'package:personal_website_v2/feature/supabase_data/s_database.dart';

class AppProvider extends ChangeNotifier {
  final database = SupabaseDatabase.instance;
  List<SocialMedia> socialData = <SocialMedia>[];
  MyInfoModel personalInfo = MyInfoModel.defaultMyInfo();
  SettingModel setting = SettingModel.defaultSetting();
  getInitData() {
    getMyInfoData();
    getSettingData();
  }

  getMyInfoData() async {
    final data = await database.getMyInfo();
    if (data != null) {
      personalInfo = data;
      notifyListeners();
    }
    notifyListeners();
  }

  getSettingData() async {
    final data = await database.getSettings();
    if (data != null) {
      setting = data;
      notifyListeners();
    }
    notifyListeners();
  }
}
