class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;
  final String role;
  final UserProfile? profile;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
    required this.role,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profilePicture: json['profilePicture'],
      role: json['role'],
      profile: json['profile'] != null ? UserProfile.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'role': role,
      'profile': profile?.toJson(),
    };
  }
}

class UserProfile {
  final double? weight;
  final double? height;
  final int? age;
  final String? fitnessLevel;
  final double? bodyFatPercentage;
  final double? muscleMass;
  final String? bio;

  UserProfile({
    this.weight,
    this.height,
    this.age,
    this.fitnessLevel,
    this.bodyFatPercentage,
    this.muscleMass,
    this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      age: json['age'],
      fitnessLevel: json['fitnessLevel'],
      bodyFatPercentage: json['bodyFatPercentage']?.toDouble(),
      muscleMass: json['muscleMass']?.toDouble(),
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'height': height,
      'age': age,
      'fitnessLevel': fitnessLevel,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
      'bio': bio,
    };
  }
}
