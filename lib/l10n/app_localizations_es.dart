// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'LIFETAP';

  @override
  String get tagline => 'Un solo toque puede salvar una vida';

  @override
  String get institution => 'Instituto Tecnológico de Tijuana';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get loginSubtitle => 'Ingresa con tu correo institucional';

  @override
  String get emailLabel => 'Correo institucional';

  @override
  String get emailHint => 'usuario@tectijuana.edu.mx';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginButton => 'Ingresar';

  @override
  String get loggingIn => 'Ingresando...';

  @override
  String get loginError => 'Correo o contraseña incorrectos';

  @override
  String get emailDomainError => 'Usa tu correo @tectijuana.edu.mx';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get panicButton => 'EMERGENCIA';

  @override
  String get panicConfirmTitle => '¿Enviar alerta de emergencia?';

  @override
  String get panicConfirmBody =>
      'Se notificará a los brigadistas más cercanos con tu ubicación.';

  @override
  String get panicConfirm => 'Sí, enviar';

  @override
  String get panicCancel => 'Cancelar';

  @override
  String get panicSending => 'Enviando alerta...';

  @override
  String get panicSent =>
      '¡Alerta enviada! Los brigadistas han sido notificados.';

  @override
  String get panicError => 'Error al enviar la alerta. Intenta de nuevo.';

  @override
  String get reportEmergency => 'Reportar Emergencia';

  @override
  String get emergencyChat => 'Chat de Emergencia';

  @override
  String get myProfile => 'Mi Perfil';

  @override
  String get home => 'Inicio';

  @override
  String get emergencyType => 'Tipo de emergencia';

  @override
  String get typeSlip => 'Caída';

  @override
  String get typeHealth => 'Problema de salud';

  @override
  String get typeAccident => 'Accidente';

  @override
  String get typeOther => 'Otro';

  @override
  String get attachMedia => 'Adjuntar foto/video (opcional)';

  @override
  String get location => 'Ubicación';

  @override
  String get locationAuto => 'Ubicación detectada automáticamente';

  @override
  String get submit => 'Enviar Reporte';

  @override
  String get submitting => 'Enviando...';

  @override
  String get reportSent => 'Reporte enviado correctamente';

  @override
  String get chatTitle => 'Chat de Emergencia';

  @override
  String get chatPlaceholder => 'Escribe un mensaje...';

  @override
  String get send => 'Enviar';

  @override
  String get brigadistaETA => 'Tiempo estimado de llegada';

  @override
  String get minutes => 'minutos';

  @override
  String get noBrigadistaAssigned => 'Esperando brigadista...';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get name => 'Nombre';

  @override
  String get controlNumber => 'Número de control';

  @override
  String get bloodType => 'Tipo de sangre';

  @override
  String get emergencyContact => 'Contacto de emergencia';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get saveProfile => 'Guardar cambios';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get activeAlerts => 'Alertas Activas';

  @override
  String get noActiveAlerts => 'Sin alertas activas';

  @override
  String get distance => 'Distancia';

  @override
  String get elapsed => 'Hace';

  @override
  String get accept => 'Aceptar';

  @override
  String get accepting => 'Aceptando...';

  @override
  String get accepted => 'Alerta aceptada';

  @override
  String get alertDetail => 'Detalle de Alerta';

  @override
  String get studentInfo => 'Información del Estudiante';

  @override
  String get openChat => 'Abrir Chat';

  @override
  String get statusEnRoute => 'En camino';

  @override
  String get statusAttending => 'Atendiendo';

  @override
  String get statusResolved => 'Resuelto';

  @override
  String get updateStatus => 'Actualizar estado';

  @override
  String get brigadistaProfile => 'Perfil Brigadista';

  @override
  String get availability => 'Disponibilidad';

  @override
  String get onDuty => 'En servicio';

  @override
  String get offDuty => 'Fuera de servicio';

  @override
  String get incidentsDashboard => 'Panel de Incidentes';

  @override
  String get filterByDate => 'Filtrar por fecha';

  @override
  String get filterByType => 'Filtrar por tipo';

  @override
  String get filterByStatus => 'Filtrar por estado';

  @override
  String get allIncidents => 'Todos';

  @override
  String get clearFilters => 'Limpiar filtros';

  @override
  String get exportReport => 'Exportar reporte';

  @override
  String get userManagement => 'Gestión de Usuarios';

  @override
  String get students => 'Estudiantes';

  @override
  String get brigadistas => 'Brigadistas';

  @override
  String get approve => 'Aprobar';

  @override
  String get block => 'Bloquear';

  @override
  String get approved => 'Aprobado';

  @override
  String get blocked => 'Bloqueado';

  @override
  String get pending => 'Pendiente';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Guardar';

  @override
  String get close => 'Cerrar';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirm => '¿Estás seguro que deseas cerrar sesión?';

  @override
  String get fallDetected => '¿Detectamos una posible caída?';

  @override
  String get fallBody =>
      'Si estás bien, presiona Cancelar. De lo contrario enviaremos una alerta automática.';

  @override
  String fallCountdown(int seconds) {
    return 'Enviando alerta en $seconds segundos...';
  }

  @override
  String get permissionLocationTitle => 'Permiso de ubicación';

  @override
  String get permissionLocationBody =>
      'LIFETAP necesita acceder a tu ubicación para enviar tu posición a los brigadistas en caso de emergencia.';

  @override
  String get permissionGranted => 'Permiso concedido';

  @override
  String get permissionDenied =>
      'Permiso denegado — algunas funciones no estarán disponibles';

  @override
  String get statusActive => 'Activo';

  @override
  String get statusResolved2 => 'Resuelto';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get languageES => 'ES';

  @override
  String get languageEN => 'EN';

  @override
  String get language => 'Idioma';

  @override
  String get noInternetOffline => 'Sin conexión — mostrando datos guardados';

  @override
  String get syncing => 'Sincronizando...';

  @override
  String get adminPanel => 'Panel de Administración';

  @override
  String get totalIncidents => 'Total de incidentes';

  @override
  String get activeNow => 'Activos ahora';

  @override
  String get resolvedToday => 'Resueltos hoy';
}
