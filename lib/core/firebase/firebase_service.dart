// lib/shared/services/firebase_service.dart

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_website_v2/core/firebase/firebase_config.dart';
import 'package:personal_website_v2/core/model/social_media.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get social media links
  Future<List<SocialMedia>> getSocialMedia() async {
    try {
      var data = await _firestore
          .collection(FirebaseConfig.personalInfoCollection)
          .doc(FirebaseConfig.socialMediaDocument)
          .get();
      if (data.data() == null) return <SocialMedia>[];
      List<SocialMedia> socialLinks = [];
      data.data()?.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          socialLinks.add(SocialMedia.fromMap(value));
        }
      });
      log(name: 'csdcnusdycsd', '${socialLinks[0].name}');
      return socialLinks;
    } catch (e) {
      log(name: 'firebase_service_error', e.toString());
      return <SocialMedia>[];
    }
  }
}
