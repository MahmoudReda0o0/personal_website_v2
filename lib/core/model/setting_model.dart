class SettingModel {
  bool skills;
  bool projects;
  bool aiChat;
  bool game;
  bool myInfo;
  bool socialMedial;

  SettingModel({
    required this.skills,
    required this.projects,
    required this.aiChat,
    required this.game,
    required this.myInfo,
    required this.socialMedial,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      skills: json['skills'] ?? false,
      projects: json['projects'] ?? false,
      aiChat: json['aiChat'] ?? false,
      game: json['game'] ?? false,
      myInfo: json['myInfo'] ?? false,
      socialMedial: json['socialMedial'] ?? false,
    );
  }
  factory SettingModel.defaultSetting() {
    return SettingModel(
      skills: false,
      projects: false,
      aiChat: false,
      game: false,
      myInfo: false,
      socialMedial: false,
    );
  }
}
