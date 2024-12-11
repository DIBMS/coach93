class Trainer {
  final String id;
  final String name;
  final String? bio;
  final String? specialization;
  final DateTime createdAt;
  final DateTime updatedAt;

  Trainer({
    required this.id,
    required this.name,
    this.bio,
    this.specialization,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bio: json['bio']?.toString(),
      specialization: json['specialization']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'specialization': specialization,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
