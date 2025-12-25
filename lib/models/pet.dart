import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  final String id;
  final String name;
  final String type; // Perro, Gato, Hamster, Otro
  final String breed;
  final DateTime birthDate;
  final double weight;
  final String gender; // Macho, Hembra
  final String? photoUrl;
  final String ownerId;
  final DateTime createdAt;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.birthDate,
    required this.weight,
    required this.gender,
    this.photoUrl,
    required this.ownerId,
    required this.createdAt,
  });

  // Calculate age in years
  int get ageInYears {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'birthDate': Timestamp.fromDate(birthDate),
      'weight': weight,
      'gender': gender,
      'photoUrl': photoUrl,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firebase document
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      breed: map['breed'] ?? '',
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      weight: (map['weight'] ?? 0.0).toDouble(),
      gender: map['gender'] ?? '',
      photoUrl: map['photoUrl'],
      ownerId: map['ownerId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Copy with method for updates
  Pet copyWith({
    String? id,
    String? name,
    String? type,
    String? breed,
    DateTime? birthDate,
    double? weight,
    String? gender,
    String? photoUrl,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
