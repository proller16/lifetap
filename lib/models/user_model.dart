import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, brigadista, admin }

class UserModel {
  final String uid;
  final String name;
  final String controlNumber;
  final UserRole role;
  final String email;
  final String? photoURL;
  final String? bloodType;
  final String? emergencyContact;
  final bool isAvailable;   // brigadista on/off duty
  final bool isApproved;
  final bool isBlocked;
  final GeoPoint? lastLocation;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.controlNumber,
    required this.role,
    required this.email,
    this.photoURL,
    this.bloodType,
    this.emergencyContact,
    this.isAvailable = true,
    this.isApproved = false,
    this.isBlocked = false,
    this.lastLocation,
    required this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      controlNumber: data['controlNumber'] ?? '',
      role: _parseRole(data['role']),
      email: data['email'] ?? '',
      photoURL: data['photoURL'],
      bloodType: data['bloodType'],
      emergencyContact: data['emergencyContact'],
      isAvailable: data['isAvailable'] ?? true,
      isApproved: data['isApproved'] ?? false,
      isBlocked: data['isBlocked'] ?? false,
      lastLocation: data['lastLocation'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'controlNumber': controlNumber,
    'role': role.name,
    'email': email,
    'photoURL': photoURL,
    'bloodType': bloodType,
    'emergencyContact': emergencyContact,
    'isAvailable': isAvailable,
    'isApproved': isApproved,
    'isBlocked': isBlocked,
    'lastLocation': lastLocation,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  UserModel copyWith({
    String? name,
    String? controlNumber,
    String? photoURL,
    String? bloodType,
    String? emergencyContact,
    bool? isAvailable,
    bool? isApproved,
    bool? isBlocked,
    GeoPoint? lastLocation,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      controlNumber: controlNumber ?? this.controlNumber,
      role: role,
      email: email,
      photoURL: photoURL ?? this.photoURL,
      bloodType: bloodType ?? this.bloodType,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      isAvailable: isAvailable ?? this.isAvailable,
      isApproved: isApproved ?? this.isApproved,
      isBlocked: isBlocked ?? this.isBlocked,
      lastLocation: lastLocation ?? this.lastLocation,
      createdAt: createdAt,
    );
  }

  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'brigadista': return UserRole.brigadista;
      case 'admin':      return UserRole.admin;
      default:           return UserRole.student;
    }
  }
}
