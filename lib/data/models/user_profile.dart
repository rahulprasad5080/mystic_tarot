/// Represents a saved person's profile details.
class UserProfile {
  final String id;
  final String name;
  final String dob;
  final String? gender;
  final String? zodiacSign;

  const UserProfile({
    required this.id,
    required this.name,
    required this.dob,
    this.gender,
    this.zodiacSign,
  });

  bool get hasData =>
      name.trim().isNotEmpty ||
      dob.trim().isNotEmpty ||
      gender != null ||
      zodiacSign != null;

  UserProfile copyWith({
    String? id,
    String? name,
    String? dob,
    String? gender,
    String? zodiacSign,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      zodiacSign: zodiacSign ?? this.zodiacSign,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'gender': gender,
      'zodiacSign': zodiacSign,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '1',
      name: json['name'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      gender: json['gender'] as String?,
      zodiacSign: json['zodiacSign'] as String?,
    );
  }
}
