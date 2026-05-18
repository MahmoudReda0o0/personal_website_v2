class AppImage {
  static const imageUrl = 'assets/images';
  static const String whatsapp = '$imageUrl/whatsapp.png';
  static const String github = '$imageUrl/github.png';
  static const String linkedin = '$imageUrl/linkedin.png';
  static const String facebook = '$imageUrl/facebook.png';
  static String getSocialImage(String socialName) {
    switch (socialName.toLowerCase()) {
      case 'whatsapp':
        return whatsapp;
      case 'github':
        return github;
      case 'linkedin':
        return linkedin;
      case 'facebook':
        return facebook;
      default:
        return github;
    }
  }
}
