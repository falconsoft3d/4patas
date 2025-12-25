import '../models/pet.dart';
import '../models/vaccine.dart';

class MockData {
  // Mock Pets
  static final List<Pet> mockPets = [
    Pet(
      id: 'pet-1',
      name: 'Max',
      type: 'Perro',
      breed: 'Golden Retriever',
      birthDate: DateTime(2021, 3, 15),
      weight: 28.5,
      gender: 'Macho',
      photoUrl: 'https://images.unsplash.com/photo-1633722715463-d30f4f325e24?w=800&q=80',
      ownerId: 'user-1',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    Pet(
      id: 'pet-2',
      name: 'Luna',
      type: 'Gato',
      breed: 'Siamés',
      birthDate: DateTime(2019, 7, 22),
      weight: 4.2,
      gender: 'Hembra',
      photoUrl: 'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=800&q=80',
      ownerId: 'user-1',
      createdAt: DateTime.now().subtract(const Duration(days: 500)),
    ),
    Pet(
      id: 'pet-3',
      name: 'Rocky',
      type: 'Perro',
      breed: 'Bulldog Francés',
      birthDate: DateTime(2022, 11, 5),
      weight: 12.8,
      gender: 'Macho',
      photoUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=800&q=80',
      ownerId: 'user-1',
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
  ];

  // Mock Vaccines
  static final List<Vaccine> mockVaccines = [
    Vaccine(
      id: 'vaccine-1',
      petId: 'pet-1',
      name: 'Rabia',
      scheduledDate: DateTime.now().add(const Duration(days: 5)),
      status: VaccineStatus.pending,
      veterinarianName: 'Dr. Sarah Wilson',
      veterinarianPhoto: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200&q=80',
      notes: 'Vacuna anual obligatoria',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Vaccine(
      id: 'vaccine-2',
      petId: 'pet-1',
      name: 'Polivalente',
      scheduledDate: DateTime.now().add(const Duration(days: 22)),
      status: VaccineStatus.pending,
      veterinarianName: 'Dr. Sarah Wilson',
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Vaccine(
      id: 'vaccine-3',
      petId: 'pet-1',
      name: 'Desparasitación',
      scheduledDate: DateTime.now().add(const Duration(days: 38)),
      status: VaccineStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Vaccine(
      id: 'vaccine-4',
      petId: 'pet-2',
      name: 'Rabia',
      scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
      status: VaccineStatus.overdue,
      veterinarianName: 'Dr. Carlos Méndez',
      notes: 'Urgente - Vencida',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    Vaccine(
      id: 'vaccine-5',
      petId: 'pet-2',
      name: 'Leucemia Felina',
      scheduledDate: DateTime.now().add(const Duration(days: 15)),
      status: VaccineStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
    ),
    Vaccine(
      id: 'vaccine-6',
      petId: 'pet-3',
      name: 'Parvovirus',
      scheduledDate: DateTime.now().subtract(const Duration(days: 90)),
      status: VaccineStatus.completed,
      completedDate: DateTime.now().subtract(const Duration(days: 90)),
      veterinarianName: 'Dr. Ana Torres',
      notes: 'Primera dosis completada',
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
  ];

  // Get vaccines for a specific pet
  static List<Vaccine> getVaccinesForPet(String petId) {
    return mockVaccines.where((v) => v.petId == petId).toList();
  }

  // Get pending vaccines count
  static int getPendingVaccinesCount() {
    return mockVaccines
        .where((v) => v.status == VaccineStatus.pending || v.status == VaccineStatus.overdue)
        .length;
  }
}
