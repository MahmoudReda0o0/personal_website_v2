// lib/shared/services/firebase_service.dart

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_website_v2/core/firebase/firebase_config.dart';
import 'package:personal_website_v2/core/model/setting_model.dart';
import 'package:personal_website_v2/core/model/social_media.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get social media links
  Future<List<SocialMedia>> getSocialMedia() async {
    try {
      var data = await _firestore
          .collection(FirebaseConfig.personalInfoCol)
          .doc(FirebaseConfig.socialMediaDoc)
          .get();
      if (data.data() == null) return <SocialMedia>[];
      List<SocialMedia> socialLinks = [];
      data.data()?.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          socialLinks.add(SocialMedia.fromMap(value));
        }
      });

      return socialLinks;
    } catch (e) {
      log(name: 'firebase_service_error', e.toString());
      return <SocialMedia>[];
    }
  }

  Future<SettingModel> getSetting() async {
    try {
      var data = await _firestore
          .collection(FirebaseConfig.personalInfoCol)
          .doc(FirebaseConfig.settingDoc)
          .get();
      if (data.data() == null) {
        return SettingModel.defaultSetting();
      }
      log(name: 'firebase_setting', '${data.data()}');

      return SettingModel.fromMap(data.data()!);
    } catch (e) {
      log(name: 'firebase_service_error', e.toString());
      return SettingModel.defaultSetting();
    }
  }

  Future<bool> updateSettingData(SettingModel value) async {
    try {
      await _firestore
          .collection(FirebaseConfig.personalInfoCol)
          .doc(FirebaseConfig.settingDoc)
          .update({
            'showSocialMedial': value.showSocialMedial,
            'showProjects': value.showProjects,
          });
      return true;
    } catch (e) {
      log(name: 'firebase_service_error', e.toString());
      return false;
    }
  }
}
