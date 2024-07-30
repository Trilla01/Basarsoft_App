import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/entry.dart';

const String USER_COLLECTION_REF = "users";
const String ENTRY_COLLECTION_REF = "entry";

class DbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final DocumentReference _userRef;
  late final CollectionReference<Entry> _entriesRef;

  DbService(String id) {
    _userRef = _firestore.collection(USER_COLLECTION_REF).doc(id);
    _entriesRef = _userRef.collection(ENTRY_COLLECTION_REF).withConverter<Entry>(
      fromFirestore: (snapshots, _) => Entry.fromJson(snapshots.data()!),
      toFirestore: (entry, _) => entry.toJson(),
    );
  }

  Stream<QuerySnapshot> getEntries() {
    return _entriesRef.snapshots();
  }

  Future<void> addEntry(Entry entry) async {
    await _entriesRef.add(entry);
  }

  Future<void> setUserNameAndSurname(String name, String surname) async {
    try {
      await _userRef.set({
        'name': name,
        'surname': surname,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error setting user name and surname: $e');
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    return await _userRef.get();
  }

  Future<int> getEntryCount() async {
    final snapshot = await _entriesRef.get();
    return snapshot.size; // The number of documents in the collection
  }
}
