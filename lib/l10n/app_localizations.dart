import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'LIFETAP'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In es, this message translates to:
  /// **'Un solo toque puede salvar una vida'**
  String get tagline;

  /// No description provided for @institution.
  ///
  /// In es, this message translates to:
  /// **'Instituto Tecnológico de Tijuana'**
  String get institution;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ingresa con tu correo institucional'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo institucional'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'usuario@tectijuana.edu.mx'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get loginButton;

  /// No description provided for @loggingIn.
  ///
  /// In es, this message translates to:
  /// **'Ingresando...'**
  String get loggingIn;

  /// No description provided for @loginError.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos'**
  String get loginError;

  /// No description provided for @emailDomainError.
  ///
  /// In es, this message translates to:
  /// **'Usa tu correo @tectijuana.edu.mx'**
  String get emailDomainError;

  /// No description provided for @forgotPassword.
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// No description provided for @panicButton.
  ///
  /// In es, this message translates to:
  /// **'EMERGENCIA'**
  String get panicButton;

  /// No description provided for @panicConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Enviar alerta de emergencia?'**
  String get panicConfirmTitle;

  /// No description provided for @panicConfirmBody.
  ///
  /// In es, this message translates to:
  /// **'Se notificará a los brigadistas más cercanos con tu ubicación.'**
  String get panicConfirmBody;

  /// No description provided for @panicConfirm.
  ///
  /// In es, this message translates to:
  /// **'Sí, enviar'**
  String get panicConfirm;

  /// No description provided for @panicCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get panicCancel;

  /// No description provided for @panicSending.
  ///
  /// In es, this message translates to:
  /// **'Enviando alerta...'**
  String get panicSending;

  /// No description provided for @panicSent.
  ///
  /// In es, this message translates to:
  /// **'¡Alerta enviada! Los brigadistas han sido notificados.'**
  String get panicSent;

  /// No description provided for @panicError.
  ///
  /// In es, this message translates to:
  /// **'Error al enviar la alerta. Intenta de nuevo.'**
  String get panicError;

  /// No description provided for @reportEmergency.
  ///
  /// In es, this message translates to:
  /// **'Reportar Emergencia'**
  String get reportEmergency;

  /// No description provided for @emergencyChat.
  ///
  /// In es, this message translates to:
  /// **'Chat de Emergencia'**
  String get emergencyChat;

  /// No description provided for @myProfile.
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get myProfile;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @emergencyType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de emergencia'**
  String get emergencyType;

  /// No description provided for @typeSlip.
  ///
  /// In es, this message translates to:
  /// **'Caída'**
  String get typeSlip;

  /// No description provided for @typeHealth.
  ///
  /// In es, this message translates to:
  /// **'Problema de salud'**
  String get typeHealth;

  /// No description provided for @typeAccident.
  ///
  /// In es, this message translates to:
  /// **'Accidente'**
  String get typeAccident;

  /// No description provided for @typeOther.
  ///
  /// In es, this message translates to:
  /// **'Otro'**
  String get typeOther;

  /// No description provided for @attachMedia.
  ///
  /// In es, this message translates to:
  /// **'Adjuntar foto/video (opcional)'**
  String get attachMedia;

  /// No description provided for @location.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get location;

  /// No description provided for @locationAuto.
  ///
  /// In es, this message translates to:
  /// **'Ubicación detectada automáticamente'**
  String get locationAuto;

  /// No description provided for @submit.
  ///
  /// In es, this message translates to:
  /// **'Enviar Reporte'**
  String get submit;

  /// No description provided for @submitting.
  ///
  /// In es, this message translates to:
  /// **'Enviando...'**
  String get submitting;

  /// No description provided for @reportSent.
  ///
  /// In es, this message translates to:
  /// **'Reporte enviado correctamente'**
  String get reportSent;

  /// No description provided for @chatTitle.
  ///
  /// In es, this message translates to:
  /// **'Chat de Emergencia'**
  String get chatTitle;

  /// No description provided for @chatPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Escribe un mensaje...'**
  String get chatPlaceholder;

  /// No description provided for @send.
  ///
  /// In es, this message translates to:
  /// **'Enviar'**
  String get send;

  /// No description provided for @brigadistaETA.
  ///
  /// In es, this message translates to:
  /// **'Tiempo estimado de llegada'**
  String get brigadistaETA;

  /// No description provided for @minutes.
  ///
  /// In es, this message translates to:
  /// **'minutos'**
  String get minutes;

  /// No description provided for @noBrigadistaAssigned.
  ///
  /// In es, this message translates to:
  /// **'Esperando brigadista...'**
  String get noBrigadistaAssigned;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get profileTitle;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @controlNumber.
  ///
  /// In es, this message translates to:
  /// **'Número de control'**
  String get controlNumber;

  /// No description provided for @bloodType.
  ///
  /// In es, this message translates to:
  /// **'Tipo de sangre'**
  String get bloodType;

  /// No description provided for @emergencyContact.
  ///
  /// In es, this message translates to:
  /// **'Contacto de emergencia'**
  String get emergencyContact;

  /// No description provided for @editProfile.
  ///
  /// In es, this message translates to:
  /// **'Editar perfil'**
  String get editProfile;

  /// No description provided for @saveProfile.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado'**
  String get profileUpdated;

  /// No description provided for @activeAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas Activas'**
  String get activeAlerts;

  /// No description provided for @noActiveAlerts.
  ///
  /// In es, this message translates to:
  /// **'Sin alertas activas'**
  String get noActiveAlerts;

  /// No description provided for @distance.
  ///
  /// In es, this message translates to:
  /// **'Distancia'**
  String get distance;

  /// No description provided for @elapsed.
  ///
  /// In es, this message translates to:
  /// **'Hace'**
  String get elapsed;

  /// No description provided for @accept.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// No description provided for @accepting.
  ///
  /// In es, this message translates to:
  /// **'Aceptando...'**
  String get accepting;

  /// No description provided for @accepted.
  ///
  /// In es, this message translates to:
  /// **'Alerta aceptada'**
  String get accepted;

  /// No description provided for @alertDetail.
  ///
  /// In es, this message translates to:
  /// **'Detalle de Alerta'**
  String get alertDetail;

  /// No description provided for @studentInfo.
  ///
  /// In es, this message translates to:
  /// **'Información del Estudiante'**
  String get studentInfo;

  /// No description provided for @openChat.
  ///
  /// In es, this message translates to:
  /// **'Abrir Chat'**
  String get openChat;

  /// No description provided for @statusEnRoute.
  ///
  /// In es, this message translates to:
  /// **'En camino'**
  String get statusEnRoute;

  /// No description provided for @statusAttending.
  ///
  /// In es, this message translates to:
  /// **'Atendiendo'**
  String get statusAttending;

  /// No description provided for @statusResolved.
  ///
  /// In es, this message translates to:
  /// **'Resuelto'**
  String get statusResolved;

  /// No description provided for @updateStatus.
  ///
  /// In es, this message translates to:
  /// **'Actualizar estado'**
  String get updateStatus;

  /// No description provided for @brigadistaProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil Brigadista'**
  String get brigadistaProfile;

  /// No description provided for @availability.
  ///
  /// In es, this message translates to:
  /// **'Disponibilidad'**
  String get availability;

  /// No description provided for @onDuty.
  ///
  /// In es, this message translates to:
  /// **'En servicio'**
  String get onDuty;

  /// No description provided for @offDuty.
  ///
  /// In es, this message translates to:
  /// **'Fuera de servicio'**
  String get offDuty;

  /// No description provided for @incidentsDashboard.
  ///
  /// In es, this message translates to:
  /// **'Panel de Incidentes'**
  String get incidentsDashboard;

  /// No description provided for @filterByDate.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por fecha'**
  String get filterByDate;

  /// No description provided for @filterByType.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por tipo'**
  String get filterByType;

  /// No description provided for @filterByStatus.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por estado'**
  String get filterByStatus;

  /// No description provided for @allIncidents.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get allIncidents;

  /// No description provided for @clearFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get clearFilters;

  /// No description provided for @exportReport.
  ///
  /// In es, this message translates to:
  /// **'Exportar reporte'**
  String get exportReport;

  /// No description provided for @userManagement.
  ///
  /// In es, this message translates to:
  /// **'Gestión de Usuarios'**
  String get userManagement;

  /// No description provided for @students.
  ///
  /// In es, this message translates to:
  /// **'Estudiantes'**
  String get students;

  /// No description provided for @brigadistas.
  ///
  /// In es, this message translates to:
  /// **'Brigadistas'**
  String get brigadistas;

  /// No description provided for @approve.
  ///
  /// In es, this message translates to:
  /// **'Aprobar'**
  String get approve;

  /// No description provided for @block.
  ///
  /// In es, this message translates to:
  /// **'Bloquear'**
  String get block;

  /// No description provided for @approved.
  ///
  /// In es, this message translates to:
  /// **'Aprobado'**
  String get approved;

  /// No description provided for @blocked.
  ///
  /// In es, this message translates to:
  /// **'Bloqueado'**
  String get blocked;

  /// No description provided for @pending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get pending;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro que deseas cerrar sesión?'**
  String get logoutConfirm;

  /// No description provided for @fallDetected.
  ///
  /// In es, this message translates to:
  /// **'¿Detectamos una posible caída?'**
  String get fallDetected;

  /// No description provided for @fallBody.
  ///
  /// In es, this message translates to:
  /// **'Si estás bien, presiona Cancelar. De lo contrario enviaremos una alerta automática.'**
  String get fallBody;

  /// No description provided for @fallCountdown.
  ///
  /// In es, this message translates to:
  /// **'Enviando alerta en {seconds} segundos...'**
  String fallCountdown(int seconds);

  /// No description provided for @permissionLocationTitle.
  ///
  /// In es, this message translates to:
  /// **'Permiso de ubicación'**
  String get permissionLocationTitle;

  /// No description provided for @permissionLocationBody.
  ///
  /// In es, this message translates to:
  /// **'LIFETAP necesita acceder a tu ubicación para enviar tu posición a los brigadistas en caso de emergencia.'**
  String get permissionLocationBody;

  /// No description provided for @permissionGranted.
  ///
  /// In es, this message translates to:
  /// **'Permiso concedido'**
  String get permissionGranted;

  /// No description provided for @permissionDenied.
  ///
  /// In es, this message translates to:
  /// **'Permiso denegado — algunas funciones no estarán disponibles'**
  String get permissionDenied;

  /// No description provided for @statusActive.
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get statusActive;

  /// No description provided for @statusResolved2.
  ///
  /// In es, this message translates to:
  /// **'Resuelto'**
  String get statusResolved2;

  /// No description provided for @statusPending.
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get statusPending;

  /// No description provided for @languageES.
  ///
  /// In es, this message translates to:
  /// **'ES'**
  String get languageES;

  /// No description provided for @languageEN.
  ///
  /// In es, this message translates to:
  /// **'EN'**
  String get languageEN;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @noInternetOffline.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión — mostrando datos guardados'**
  String get noInternetOffline;

  /// No description provided for @syncing.
  ///
  /// In es, this message translates to:
  /// **'Sincronizando...'**
  String get syncing;

  /// No description provided for @adminPanel.
  ///
  /// In es, this message translates to:
  /// **'Panel de Administración'**
  String get adminPanel;

  /// No description provided for @totalIncidents.
  ///
  /// In es, this message translates to:
  /// **'Total de incidentes'**
  String get totalIncidents;

  /// No description provided for @activeNow.
  ///
  /// In es, this message translates to:
  /// **'Activos ahora'**
  String get activeNow;

  /// No description provided for @resolvedToday.
  ///
  /// In es, this message translates to:
  /// **'Resueltos hoy'**
  String get resolvedToday;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
