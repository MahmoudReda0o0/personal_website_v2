import 'package:mivo/core/app/app_setting.dart';

/// A personal link (?c=code) made for one person or company.
class CustomLink {
  final int id;
  final String code;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime createdAt;

  const CustomLink({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
  });

  /// The link to send, e.g. https://.../personal_website_v2/?c=k7f3q2
  String get url => '${AppSetting.websiteUrl}?c=$code';

  factory CustomLink.fromJson(Map<String, dynamic> json) {
    final description = (json['description'] as String?)?.trim();
    return CustomLink(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      description: (description == null || description.isEmpty)
          ? null
          : description,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// What a visitor sees when they open a personal link.
class LinkGreeting {
  final String name;
  final String? description;

  const LinkGreeting({required this.name, this.description});
}
