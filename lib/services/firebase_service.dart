import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/issue_model.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Authentication
  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  }

  Future<User?> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Issues
  Future<void> reportIssue(Issue issue, File? imageFile) async {
    String imageUrl = '';
    if (imageFile != null) {
      String fileName = const Uuid().v4();
      Reference ref = _storage.ref().child('issue_images/$fileName.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    issue.imageUrl = imageUrl;
    await _firestore.collection('issues').doc(issue.id).set(issue.toMap());
  }

  Stream<List<Issue>> getIssues() {
    return _firestore.collection('issues').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Issue.fromMap(doc.data())).toList());
  }
}
