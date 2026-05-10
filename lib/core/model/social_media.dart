// lib/shared/models/social_media.dart
class SocialMedia {
  final String name;
  final String link;

  SocialMedia({required this.name, required this.link});

  factory SocialMedia.fromMap(Map<String, dynamic> map) {
    return SocialMedia(name: map['name'] ?? '', link: map['link'] ?? '');
  }
}
