import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Authentication Methods
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Conversation Methods
  Stream<QuerySnapshot> getConversations() {
    final userId = currentUser?.uid;
    if (userId == null) throw 'User not authenticated';

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .orderBy('metadata.createdAt', descending: true)
        .snapshots();
  }

  Future<DocumentReference> createConversation(String title) async {
    final userId = currentUser?.uid;
    if (userId == null) throw 'User not authenticated';

    final conversationRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .add({
      'metadata': {
        'title': title,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'updatedAt': FieldValue.serverTimestamp(),
      }
    });

    return conversationRef;
  }

  // Message Methods
  Stream<QuerySnapshot> getMessages(String conversationId) {
    final userId = currentUser?.uid;
    if (userId == null) throw 'User not authenticated';

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    required String conversationId,
    required String message,
    required String sender,
  }) async {
    final userId = currentUser?.uid;
    if (userId == null) throw 'User not authenticated';

    final conversationRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('conversations')
        .doc(conversationId);

    // Add message to messages subcollection
    await conversationRef.collection('messages').add({
      'message': message,
      'sender': sender,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await conversationRef.set({
      'metadata': {
        'title': 'Chat with LegalBot',
        'lastMessage': message,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }
    }, SetOptions(merge: true));
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
