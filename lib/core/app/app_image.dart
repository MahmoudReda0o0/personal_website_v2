class AppImage {
  static const imageUrl = 'assets/images';
  static const String whatsapp = '$imageUrl/whatsapp.png';
  static const String github = '$imageUrl/github.png';
  static const String linkedin = '$imageUrl/linkedin.png';
  static const String facebook = '$imageUrl/facebook.png';

  // ----------------------- Mivo Images -----------------------
  static const String imageMivoUrl = '$imageUrl/mivo';
  static const String m_loading = '$imageMivoUrl/loading.png';
  static const String m_sad = '$imageMivoUrl/sad.png';
  static const String m_thinking = '$imageMivoUrl/thinking.png';
  static const String m_typing = '$imageMivoUrl/typing.png';
  static const String m_success = '$imageMivoUrl/success.png';
  static const String m_error = '$imageMivoUrl/error.png';

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
