// ============================================================
//  LIFETAP — Script de usuarios de prueba
//  Ejecutar UNA VEZ para poblar Firebase con datos iniciales.
//
//  Instrucciones:
//    1. Asegúrate de tener Firebase configurado (flutterfire configure)
//    2. Desde la raíz del proyecto corre:
//         flutter run -t tool/seed_users.dart
//    O si prefieres ejecutarlo como script de Dart puro:
//         dart run tool/seed_users.dart
//
//  ⚠️  Solo ejecutar una vez. Crea usuarios en Auth + Firestore.
// ============================================================

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

// ── Datos de prueba ──────────────────────────────────────────────────────────
final List<Map<String, dynamic>> _testUsers = [
  {
    'email':         'estudiante@tectijuana.edu.mx',
    'password':      'Test1234!',
    'name':          'Ana García López',
    'controlNumber': '21340001',
    'role':          'student',
    'bloodType':     'O+',
    'emergencyContact': 'María López — 664-123-4567',
    'isApproved':    true,
    'isAvailable':   true,
    'isBlocked':     false,
  },
  {
    'email':         'estudiante2@tectijuana.edu.mx',
    'password':      'Test1234!',
    'name':          'Carlos Ramírez Torres',
    'controlNumber': '21340002',
    'role':          'student',
    'bloodType':     'A+',
    'emergencyContact': 'Roberto Ramírez — 664-987-6543',
    'isApproved':    true,
    'isAvailable':   true,
    'isBlocked':     false,
  },
  {
    'email':         'brigadista@tectijuana.edu.mx',
    'password':      'Test1234!',
    'name':          'Luis Hernández Méndez',
    'controlNumber': '19340010',
    'role':          'brigadista',
    'bloodType':     'B+',
    'emergencyContact': null,
    'isApproved':    true,
    'isAvailable':   true,
    'isBlocked':     false,
  },
  {
    'email':         'brigadista2@tectijuana.edu.mx',
    'password':      'Test1234!',
    'name':          'Sofía Martínez Vega',
    'controlNumber': '20340015',
    'role':          'brigadista',
    'bloodType':     'AB-',
    'emergencyContact': null,
    'isApproved':    true,
    'isAvailable':   false,
    'isBlocked':     false,
  },
  {
    'email':         'admin@tectijuana.edu.mx',
    'password':      'Admin1234!',
    'name':          'Dr. Jorge Mendoza Rivera',
    'controlNumber': '00000001',
    'role':          'admin',
    'bloodType':     null,
    'emergencyContact': null,
    'isApproved':    true,
    'isAvailable':   true,
    'isBlocked':     false,
  },
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('\n🚀 LIFETAP — Creando usuarios de prueba...\n');

  int created = 0;
  int skipped = 0;

  for (final userData in _testUsers) {
    final email    = userData['email'] as String;
    final password = userData['password'] as String;

    try {
      // 1. Crear usuario en Firebase Auth
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      // 2. Crear documento en Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid':              uid,
        'name':             userData['name'],
        'controlNumber':    userData['controlNumber'],
        'role':             userData['role'],
        'email':            email,
        'photoURL':         null,
        'bloodType':        userData['bloodType'],
        'emergencyContact': userData['emergencyContact'],
        'isApproved':       userData['isApproved'],
        'isAvailable':      userData['isAvailable'],
        'isBlocked':        userData['isBlocked'],
        'lastLocation':     null,
        'createdAt':        Timestamp.now(),
      });

      created++;
      print('  ✅  ${userData['role'].toString().padRight(12)} → $email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        skipped++;
        print('  ⚠️   Ya existe → $email (omitido)');
      } else {
        print('  ❌  Error en $email → ${e.code}: ${e.message}');
      }
    } catch (e) {
      print('  ❌  Error inesperado en $email → $e');
    }
  }

  print('\n─────────────────────────────────────────');
  print('  ✅  Creados: $created');
  print('  ⚠️   Omitidos (ya existían): $skipped');
  print('─────────────────────────────────────────');
  print('\n📋 Credenciales de prueba:\n');
  print('  ROL           CORREO                              CONTRASEÑA');
  print('  ─────────     ──────────────────────────────────  ──────────');
  print('  student       estudiante@tectijuana.edu.mx         Test1234!');
  print('  student       estudiante2@tectijuana.edu.mx        Test1234!');
  print('  brigadista    brigadista@tectijuana.edu.mx         Test1234!');
  print('  brigadista    brigadista2@tectijuana.edu.mx        Test1234!');
  print('  admin         admin@tectijuana.edu.mx              Admin1234!');
  print('\n🎉 ¡Listo! Ya puedes iniciar sesión en LIFETAP.\n');
}
