// lib/shared/models/social_media.dart
class SocialMedia {
  final String whatsapp;
  final String facebook;
  final String linkedin;
  final String github;
  final String email;

  SocialMedia({
    required this.whatsapp,
    required this.facebook,
    required this.linkedin,
    required this.github,
    required this.email,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      whatsapp: json['whats_app'] ?? '',
      facebook: json['facebook'] ?? '',
      linkedin: json['linkedin'] ?? '',
      github: json['github'] ?? '',
      email: json['email'] ?? '',
    );
  }

  factory SocialMedia.defaultSocialMedia() {
    return SocialMedia(
      whatsapp: '',
      facebook: '',
      linkedin: '',
      github: '',
      email: '',
    );
  }
}
