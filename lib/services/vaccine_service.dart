import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vaccine.dart';

class VaccineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all vaccines for a pet
  Stream<List<Vaccine>> getPetVaccines(String petId) {
    return _firestore
        .collection('vaccines')
        .where('petId', isEqualTo: petId)
        .orderBy('scheduledDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Vaccine.fromMap(doc.data())).toList();
    });
  }

  // Get upcoming vaccines for a pet
  Stream<List<Vaccine>> getUpcomingVaccines(String petId) {
    return _firestore
        .collection('vaccines')
        .where('petId', isEqualTo: petId)
        .where('status', whereIn: ['pending', 'overdue'])
        .orderBy('scheduledDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Vaccine.fromMap(doc.data())).toList();
    });
  }

  // Get vaccine history for a pet
  Stream<List<Vaccine>> getVaccineHistory(String petId) {
    return _firestore
        .collection('vaccines')
        .where('petId', isEqualTo: petId)
        .where('status', isEqualTo: 'completed')
        .orderBy('completedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Vaccine.fromMap(doc.data())).toList();
    });
  }

  // Add new vaccine
  Future<String?> addVaccine(Vaccine vaccine) async {
    try {
      await _firestore.collection('vaccines').doc(vaccine.id).set(vaccine.toMap());
      return vaccine.id;
    } catch (e) {
      print('Error adding vaccine: $e');
      return null;
    }
  }

  // Update vaccine
  Future<bool> updateVaccine(Vaccine vaccine) async {
    try {
      await _firestore.collection('vaccines').doc(vaccine.id).update(vaccine.toMap());
      return true;
    } catch (e) {
      print('Error updating vaccine: $e');
      return false;
    }
  }

  // Mark vaccine as completed
  Future<bool> markVaccineCompleted(String vaccineId) async {
    try {
      await _firestore.collection('vaccines').doc(vaccineId).update({
        'status': 'completed',
        'completedDate': Timestamp.fromDate(DateTime.now()),
      });
      return true;
    } catch (e) {
      print('Error marking vaccine as completed: $e');
      return false;
    }
  }

  // Delete vaccine
  Future<bool> deleteVaccine(String vaccineId) async {
    try {
      await _firestore.collection('vaccines').doc(vaccineId).delete();
      return true;
    } catch (e) {
      print('Error deleting vaccine: $e');
      return false;
    }
  }

  // Get pending vaccine count for a pet
  Future<int> getPendingVaccineCount(String petId) async {
    try {
      final snapshot = await _firestore
          .collection('vaccines')
          .where('petId', isEqualTo: petId)
          .where('status', isEqualTo: 'pending')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting pending vaccine count: $e');
      return 0;
    }
  }
}
