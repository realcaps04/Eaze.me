class UserSettings {
  UserSettings({
    required this.id,
    required this.userId,
    required this.darkMode,
    required this.notificationsEnabled,
    required this.language,
  });

  final String id;
  final String userId;
  final bool darkMode;
  final bool notificationsEnabled;
  final String language;

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      darkMode: json['dark_mode'] as bool? ?? false,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      language: (json['language'] as String?) ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'dark_mode': darkMode,
      'notifications_enabled': notificationsEnabled,
      'language': language,
    };
  }
}

