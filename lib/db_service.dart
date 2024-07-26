import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application/entry.dart';

const String ENTRY_COLLECTION_REF = "entry";

class DbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final CollectionReference _entriesRef;

  DbService(){
    _entriesRef = _firestore.collection(ENTRY_COLLECTION_REF).withConverter<Entry>(
      fromFirestore: (snapshots, _) => Entry.fromJson(snapshots.data()!,), 
      toFirestore: (entry, _) => entry.toJson());
  }

  Stream<QuerySnapshot> getEntries(){
    return _entriesRef.snapshots();
  }

  void addEntry(Entry entry) async{
    _entriesRef.add(entry);
  }

}