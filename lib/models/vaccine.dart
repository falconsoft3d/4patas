import 'package:cloud_firestore/cloud_firestore.dart';

enum VaccineStatus {
  pending,
  completed,
  overdue,
}

class Vaccine {
  final String id;
  final String petId;
  final String name;
  final DateTime scheduledDate;
  final VaccineStatus status;
  final String? veterinarianName;
  final String? veterinarianPhoto;
  final String? notes;
  final DateTime? completedDate;
  final DateTime createdAt;

  Vaccine({
    required this.id,
    required this.petId,
    required this.name,
    required this.scheduledDate,
    required this.status,
    this.veterinarianName,
    this.veterinarianPhoto,
    this.notes,
    this.completedDate,
    required this.createdAt,
  });

  // Check if vaccine is overdue
  bool get isOverdue {
    if (status == VaccineStatus.completed) return false;
    return DateTime.now().isAfter(scheduledDate);
  }

  // Check if vaccine is due soon (within 7 days)
  bool get isDueSoon {
    if (status == VaccineStatus.completed) return false;
    final daysUntilDue = scheduledDate.difference(DateTime.now()).inDays;
    return daysUntilDue >= 0 && daysUntilDue <= 7;
  }

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'petId': petId,
      'name': name,
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'status': status.toString().split('.').last,
      'veterinarianName': veterinarianName,
      'veterinarianPhoto': veterinarianPhoto,
      'notes': notes,
      'completedDate': completedDate != null ? Timestamp.fromDate(completedDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firebase document
  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'] ?? '',
      petId: map['petId'] ?? '',
      name: map['name'] ?? '',
      scheduledDate: (map['scheduledDate'] as Timestamp).toDate(),
      status: VaccineStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => VaccineStatus.pending,
      ),
      veterinarianName: map['veterinarianName'],
      veterinarianPhoto: map['veterinarianPhoto'],
      notes: map['notes'],
      completedDate: map['completedDate'] != null
          ? (map['completedDate'] as Timestamp).toDate()
          : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Copy with method for updates
  Vaccine copyWith({
    String? id,
    String? petId,
    String? name,
    DateTime? scheduledDate,
    VaccineStatus? status,
    String? veterinarianName,
    String? veterinarianPhoto,
    String? notes,
    DateTime? completedDate,
    DateTime? createdAt,
  }) {
    return Vaccine(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      name: name ?? this.name,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      veterinarianPhoto: veterinarianPhoto ?? this.veterinarianPhoto,
      notes: notes ?? this.notes,
      completedDate: completedDate ?? this.completedDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
