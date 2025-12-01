import '../cli/questions.dart';

class BackendTemplates {
  static String generateAuthService(ProjectConfig config) {
    if (config.backend == 'Firebase') {
      return _generateFirebaseAuthService();
    } else if (config.backend == 'Supabase') {
      return _generateSupabaseAuthService();
    } else if (config.backend == 'Appwrite') {
      return _generateAppwriteAuthService();
    }
    return '';
  }

  static String _generateFirebaseAuthService() {
    return '''
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email & password
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with email & password
  Future<UserCredential?> registerWithEmailPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
''';
  }

  static String _generateSupabaseAuthService() {
    return '''
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign in with email & password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with email & password
  Future<AuthResponse> registerWithEmailPassword(String email, String password) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }
}
''';
  }

  static String _generateAppwriteAuthService() {
    return '''
import 'package:appwrite/appwrite.dart';

class AuthService {
  late Client _client;
  late Account _account;

  AuthService() {
    _client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1') // Your Appwrite Endpoint
        .setProject('YOUR_PROJECT_ID'); // Your project ID
    _account = Account(_client);
  }

  // Sign in with email & password
  Future<dynamic> signInWithEmailPassword(String email, String password) async {
    try {
      return await _account.createEmailSession(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Register with email & password
  Future<dynamic> registerWithEmailPassword(String email, String password, String name) async {
    try {
      return await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get current user
  Future<dynamic> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _account.deleteSession(sessionId: 'current');
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _account.createRecovery(
      email: email,
      url: 'YOUR_RECOVERY_URL',
    );
  }
}
''';
  }

  static String generateDatabaseService(ProjectConfig config) {
    if (config.backend == 'Firebase') {
      return _generateFirebaseDatabaseService();
    } else if (config.backend == 'Supabase') {
      return _generateSupabaseDatabaseService();
    } else if (config.backend == 'Appwrite') {
      return _generateAppwriteDatabaseService();
    }
    return '';
  }

  static String _generateFirebaseDatabaseService() {
    return '''
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create
  Future<void> createDocument(String collection, String id, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(id).set(data);
  }

  // Read
  Future<DocumentSnapshot> getDocument(String collection, String id) async {
    return await _db.collection(collection).doc(id).get();
  }

  // Update
  Future<void> updateDocument(String collection, String id, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(id).update(data);
  }

  // Delete
  Future<void> deleteDocument(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  // Stream collection
  Stream<QuerySnapshot> streamCollection(String collection) {
    return _db.collection(collection).snapshots();
  }
}
''';
  }

  static String _generateSupabaseDatabaseService() {
    return '''
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Create
  Future<void> createDocument(String table, Map<String, dynamic> data) async {
    await _supabase.from(table).insert(data);
  }

  // Read
  Future<List<Map<String, dynamic>>> getDocuments(String table) async {
    return await _supabase.from(table).select();
  }

  // Update
  Future<void> updateDocument(String table, String id, Map<String, dynamic> data) async {
    await _supabase.from(table).update(data).eq('id', id);
  }

  // Delete
  Future<void> deleteDocument(String table, String id) async {
    await _supabase.from(table).delete().eq('id', id);
  }

  // Stream data
  Stream<List<Map<String, dynamic>>> streamTable(String table) {
    return _supabase
        .from(table)
        .stream(primaryKey: ['id']);
  }
}
''';
  }

  static String _generateAppwriteDatabaseService() {
    return '''
import 'package:appwrite/appwrite.dart';

class DatabaseService {
  late Client _client;
  late Databases _databases;

  DatabaseService() {
    _client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('YOUR_PROJECT_ID');
    _databases = Databases(_client);
  }

  // Create
  Future<dynamic> createDocument(
    String databaseId,
    String collectionId,
    Map<String, dynamic> data,
  ) async {
    return await _databases.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: ID.unique(),
      data: data,
    );
  }

  // Read
  Future<dynamic> getDocument(
    String databaseId,
    String collectionId,
    String documentId,
  ) async {
    return await _databases.getDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: documentId,
    );
  }

  // Update
  Future<dynamic> updateDocument(
    String databaseId,
    String collectionId,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    return await _databases.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: documentId,
      data: data,
    );
  }

  // Delete
  Future<void> deleteDocument(
    String databaseId,
    String collectionId,
    String documentId,
  ) async {
    await _databases.deleteDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: documentId,
    );
  }
}
''';
  }
}
