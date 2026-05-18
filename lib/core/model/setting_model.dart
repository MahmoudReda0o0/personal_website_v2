class SettingModel {
  bool showProjects;
  bool showSocialMedial;

  SettingModel({required this.showProjects, required this.showSocialMedial});

  static defaultSetting() {
    return SettingModel(showProjects: false, showSocialMedial: false);
  }

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      showProjects: map['showProjects'] ?? false,
      showSocialMedial: map['showSocialMedial'] ?? false,
    );
  }
}
