import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get all pets for current user
  Stream<List<Pet>> getUserPets() {
    final userId = currentUserId ?? 'guest';
    
    return _firestore
        .collection('pets')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final pets = snapshot.docs.map((doc) => Pet.fromMap(doc.data())).toList();
      // Sort in memory instead of using orderBy (to avoid index requirement)
      pets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return pets;
    });
  }

  // Get single pet by ID
  Future<Pet?> getPetById(String petId) async {
    try {
      final doc = await _firestore.collection('pets').doc(petId).get();
      if (doc.exists) {
        return Pet.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting pet: $e');
      return null;
    }
  }

  // Add new pet
  Future<String?> addPet(Pet pet) async {
    try {
      await _firestore.collection('pets').doc(pet.id).set(pet.toMap());
      return pet.id;
    } catch (e) {
      print('Error adding pet: $e');
      return null;
    }
  }

  // Update pet
  Future<bool> updatePet(Pet pet) async {
    try {
      await _firestore.collection('pets').doc(pet.id).update(pet.toMap());
      return true;
    } catch (e) {
      print('Error updating pet: $e');
      return false;
    }
  }

  // Delete pet
  Future<bool> deletePet(String petId) async {
    try {
      await _firestore.collection('pets').doc(petId).delete();
      return true;
    } catch (e) {
      print('Error deleting pet: $e');
      return false;
    }
  }

  // Get pet count for user
  Future<int> getPetCount() async {
    final userId = currentUserId ?? 'guest';
    
    try {
      final snapshot = await _firestore
          .collection('pets')
          .where('ownerId', isEqualTo: userId)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting pet count: $e');
      return 0;
    }
  }
}
