import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _cachedUserKey = 'cached_user_uid';
  static const String _allowedDomain  = '@tectijuana.edu.mx';

  // ── Current User Stream ───────────────────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentFirebaseUser => _auth.currentUser;

  // ── Sign In ───────────────────────────────────────────────────────────────
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    if (!email.endsWith(_allowedDomain)) {
      throw AuthException('emailDomainError');
    }
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    final model = await _fetchUserModel(user.uid);

    // Cache UID for offline display
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cachedUserKey, user.uid);

    return model;
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedUserKey);
    await _auth.signOut();
  }

  // ── Fetch user profile from Firestore ────────────────────────────────────
  Future<UserModel> _fetchUserModel(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) throw AuthException('userNotFound');
    return UserModel.fromFirestore(doc);
  }

  Future<UserModel?> fetchCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    try {
      return await _fetchUserModel(user.uid);
    } catch (_) {
      return null;
    }
  }

  // ── Stream user profile (live updates) ───────────────────────────────────
  Stream<UserModel?> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  // ── Update user profile ───────────────────────────────────────────────────
  Future<void> updateUserProfile(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toFirestore());
  }

  // ── Update availability (brigadista) ─────────────────────────────────────
  Future<void> setAvailability(String uid, bool available) async {
    await _db.collection('users').doc(uid).update({'isAvailable': available});
  }

  // ── Update last known location ────────────────────────────────────────────
  Future<void> updateLocation(String uid, double lat, double lng) async {
    await _db.collection('users').doc(uid).update({
      'lastLocation': GeoPoint(lat, lng),
    });
  }

  // ── Password reset ────────────────────────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ── Admin: approve/block user ─────────────────────────────────────────────
  Future<void> setUserApproval(String uid, bool approved) async {
    await _db.collection('users').doc(uid).update({'isApproved': approved});
  }

  Future<void> setUserBlocked(String uid, bool blocked) async {
    await _db.collection('users').doc(uid).update({'isBlocked': blocked});
  }

  // ── Admin: list users by role ─────────────────────────────────────────────
  Stream<List<UserModel>> usersStream({UserRole? role}) {
    Query<Map<String, dynamic>> q = _db.collection('users');
    if (role != null) q = q.where('role', isEqualTo: role.name);
    return q.snapshots().map(
      (snap) => snap.docs.map(UserModel.fromFirestore).toList(),
    );
  }
}

class AuthException implements Exception {
  final String code;
  AuthException(this.code);
  @override
  String toString() => 'AuthException: $code';
}
