class TrainerProfile {
  final String id;
  final String userId;
  final String userEmail;
  final List<String> specializations;
  final String? bio;
  final double hourlyRate;
  final int? yearsOfExperience;
  final List<String>? certifications;
  final bool isVerified;
  final double? latitude;
  final double? longitude;
  final bool isAvailableForHire;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrainerProfile({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.specializations,
    this.bio,
    required this.hourlyRate,
    this.yearsOfExperience,
    this.certifications,
    required this.isVerified,
    this.latitude,
    this.longitude,
    required this.isAvailableForHire,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrainerProfile.fromJson(Map<String, dynamic> json) {
    return TrainerProfile(
      id: json['id'],
      userId: json['user']['id'],
      userEmail: json['user']['email'],
      specializations: List<String>.from(json['specializations']),
      bio: json['bio'],
      hourlyRate: json['hourlyRate'].toDouble(),
      yearsOfExperience: json['yearsOfExperience'],
      certifications: json['certifications'] != null 
        ? List<String>.from(json['certifications'])
        : null,
      isVerified: json['isVerified'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isAvailableForHire: json['isAvailableForHire'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': {
        'id': userId,
        'email': userEmail,
      },
      'specializations': specializations,
      'bio': bio,
      'hourlyRate': hourlyRate,
      'yearsOfExperience': yearsOfExperience,
      'certifications': certifications,
      'isVerified': isVerified,
      'latitude': latitude,
      'longitude': longitude,
      'isAvailableForHire': isAvailableForHire,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
