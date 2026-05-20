# 🚨 LIFETAP
### Emergency Response App — Instituto Tecnológico de Tijuana
> *"Un solo toque puede salvar una vida"*

---

## 📋 Descripción

LIFETAP es una aplicación móvil de respuesta a emergencias para el campus del Instituto Tecnológico de Tijuana. Conecta estudiantes que necesitan ayuda urgente con brigadistas capacitados en tiempo real.

## ⚙️ Tech Stack

| Tecnología | Uso |
|---|---|
| Flutter 3.x | Framework móvil (iOS + Android) |
| Firebase Auth | Autenticación con correo institucional |
| Cloud Firestore | Alertas, usuarios e incidentes |
| Firebase Realtime DB | Chat en tiempo real |
| Firebase Messaging | Push notifications (FCM) |
| Google Maps Flutter | Mapa de ubicación de emergencias |
| Riverpod | State management |
| go_router | Navegación |

---

## 🚀 Pasos para ejecutar el proyecto

### 1. Instalar dependencias de sistema
- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.16
- [Android Studio](https://developer.android.com/studio) con Android SDK 34
- [Git](https://git-scm.com/)
- [Node.js LTS](https://nodejs.org/) (para Firebase CLI)

### 2. Instalar Firebase CLI y FlutterFire CLI
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

### 3. Crear proyecto Firebase
1. Ve a [Firebase Console](https://console.firebase.google.com)
2. Crea un proyecto llamado `lifetap-itt`
3. Activa: **Authentication** (Email/Password), **Firestore**, **Realtime Database**, **Storage**, **Cloud Messaging**

### 4. Configurar FlutterFire
```bash
cd lifetap
flutterfire configure --project=lifetap-itt
```
Esto sobrescribe `lib/firebase_options.dart` con tus credenciales reales.

### 5. Obtener API Key de Google Maps
1. Ve a [Google Cloud Console](https://console.cloud.google.com)
2. Habilita: **Maps SDK for Android** y **Maps SDK for iOS**
3. Crea una API Key
4. En `android/app/src/main/AndroidManifest.xml`, reemplaza `YOUR_GOOGLE_MAPS_ANDROID_API_KEY` con tu key

### 6. Instalar dependencias Flutter
```bash
flutter pub get
```

### 7. Ejecutar la app
```bash
flutter run
```

---

## 📁 Estructura del proyecto

```
lifetap/
├── lib/
│   ├── main.dart              # Entry point
│   ├── firebase_options.dart  # Credenciales Firebase
│   ├── app/
│   │   ├── app.dart           # MaterialApp con i18n y router
│   │   └── router.dart        # Rutas con go_router
│   ├── l10n/
│   │   ├── app_es.arb         # Strings en Español
│   │   └── app_en.arb         # Strings en Inglés
│   ├── theme/
│   │   └── app_theme.dart     # Colores, tipografía, estilos
│   ├── models/                # UserModel, AlertModel, MessageModel
│   ├── services/              # Auth, Alert, Chat, Location, FCM, Sensor
│   ├── providers/             # Riverpod providers
│   ├── screens/
│   │   ├── auth/              # Login
│   │   ├── student/           # Home, Reporte, Chat, Perfil
│   │   ├── brigadista/        # Dashboard, Detalle, Perfil
│   │   └── admin/             # Dashboard, Usuarios
│   └── widgets/               # PanicButton, AlertCard, ChatBubble, etc.
├── android/
│   └── app/
│       ├── google-services.json   # ⚠️ Reemplazar con tus credenciales
│       └── src/main/AndroidManifest.xml
└── ios/
    └── Runner/
        └── GoogleService-Info.plist  # ⚠️ Reemplazar con tus credenciales
```

---

## 👥 Roles de usuario

| Rol | Acceso | Pantalla inicial |
|---|---|---|
| `student` | Botón pánico, chat, perfil | `/student` |
| `brigadista` | Dashboard alertas, mapa, chat | `/brigadista` |
| `admin` | Incidentes, gestión usuarios | `/admin` |

El rol se guarda en Firestore → `users/{uid}.role`

---

## 🔥 Reglas de Firestore (recomendadas)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuth() { return request.auth != null; }
    function role() { return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role; }
    function isAdmin() { return role() == 'admin'; }
    function isBrigadista() { return role() == 'brigadista'; }
    function isStudent() { return role() == 'student'; }

    match /users/{uid} {
      allow read: if isAuth();
      allow write: if request.auth.uid == uid || isAdmin();
    }
    match /alerts/{alertId} {
      allow read: if isAuth();
      allow create: if isStudent();
      allow update: if isBrigadista() || isAdmin();
      allow delete: if isAdmin();
    }
  }
}
```

---

## 🌍 Idiomas soportados

- 🇲🇽 Español (default)
- 🇺🇸 English

Toggle disponible en la barra superior de cada pantalla.

---

## 📱 Pantallas implementadas

### Estudiante
- ✅ Login con correo @itijuana.edu.mx
- ✅ Pantalla principal con botón pánico animado
- ✅ Detección de caída automática (acelerómetro)
- ✅ Reporte de emergencia con tipo + foto
- ✅ Chat en tiempo real con brigadista
- ✅ Perfil editable

### Brigadista
- ✅ Dashboard de alertas activas ordenadas por distancia
- ✅ Toggle de disponibilidad
- ✅ Detalle de alerta con Google Maps
- ✅ Flujo de estados: En camino → Atendiendo → Resuelto
- ✅ Chat con el estudiante
- ✅ Perfil

### Admin
- ✅ Dashboard con estadísticas
- ✅ Filtros por tipo, estado y fecha
- ✅ Gestión de usuarios: aprobar / bloquear

---

## 📞 Soporte

Instituto Tecnológico de Tijuana — Brigada de Primeros Auxilios

---
*Desarrollado con Flutter + Firebase*
