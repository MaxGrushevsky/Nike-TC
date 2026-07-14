class UserProfile {
  const UserProfile({
    required this.firstName,
    required this.lastName,
    this.hometown,
    this.bio,
    this.avatarPath,
    required this.memberSince,
  });

  final String firstName;
  final String lastName;
  final String? hometown;
  final String? bio;
  final String? avatarPath;
  final DateTime memberSince;

  String get displayName => '${firstName.trim()} ${lastName.trim()}'.trim();

  String get uppercaseDisplayName => displayName.toUpperCase();

  String get memberSinceLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return 'Member Since ${months[memberSince.month - 1]} ${memberSince.year}';
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? hometown,
    String? bio,
    String? avatarPath,
    DateTime? memberSince,
    bool clearHometown = false,
    bool clearBio = false,
    bool clearAvatarPath = false,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      hometown: clearHometown ? null : hometown ?? this.hometown,
      bio: clearBio ? null : bio ?? this.bio,
      avatarPath: clearAvatarPath ? null : avatarPath ?? this.avatarPath,
      memberSince: memberSince ?? this.memberSince,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'hometown': hometown,
      'bio': bio,
      'avatarPath': avatarPath,
      'memberSince': memberSince.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] as String? ?? 'Test',
      lastName: json['lastName'] as String? ?? 'User',
      hometown: json['hometown'] as String?,
      bio: json['bio'] as String?,
      avatarPath: json['avatarPath'] as String?,
      memberSince: DateTime.tryParse(json['memberSince'] as String? ?? '') ??
          DateTime(2020, 3, 1),
    );
  }

  static UserProfile get defaultProfile => UserProfile(
        firstName: 'Test',
        lastName: 'User',
        memberSince: DateTime(2020, 3, 1),
      );
}
