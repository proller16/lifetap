// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LIFETAP';

  @override
  String get tagline => 'One tap can save a life';

  @override
  String get institution => 'Instituto Tecnológico de Tijuana';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginSubtitle => 'Use your institutional email';

  @override
  String get emailLabel => 'Institutional email';

  @override
  String get emailHint => 'user@tectijuana.edu.mx';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loggingIn => 'Signing in...';

  @override
  String get loginError => 'Incorrect email or password';

  @override
  String get emailDomainError => 'Use your @tectijuana.edu.mx email';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get panicButton => 'EMERGENCY';

  @override
  String get panicConfirmTitle => 'Send emergency alert?';

  @override
  String get panicConfirmBody =>
      'Nearby first responders will be notified with your location.';

  @override
  String get panicConfirm => 'Yes, send';

  @override
  String get panicCancel => 'Cancel';

  @override
  String get panicSending => 'Sending alert...';

  @override
  String get panicSent => 'Alert sent! First responders have been notified.';

  @override
  String get panicError => 'Failed to send alert. Please try again.';

  @override
  String get reportEmergency => 'Report Emergency';

  @override
  String get emergencyChat => 'Emergency Chat';

  @override
  String get myProfile => 'My Profile';

  @override
  String get home => 'Home';

  @override
  String get emergencyType => 'Emergency type';

  @override
  String get typeSlip => 'Fall';

  @override
  String get typeHealth => 'Health issue';

  @override
  String get typeAccident => 'Accident';

  @override
  String get typeOther => 'Other';

  @override
  String get attachMedia => 'Attach photo/video (optional)';

  @override
  String get location => 'Location';

  @override
  String get locationAuto => 'Location detected automatically';

  @override
  String get submit => 'Submit Report';

  @override
  String get submitting => 'Submitting...';

  @override
  String get reportSent => 'Report submitted successfully';

  @override
  String get chatTitle => 'Emergency Chat';

  @override
  String get chatPlaceholder => 'Type a message...';

  @override
  String get send => 'Send';

  @override
  String get brigadistaETA => 'Estimated arrival time';

  @override
  String get minutes => 'minutes';

  @override
  String get noBrigadistaAssigned => 'Waiting for first responder...';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get name => 'Name';

  @override
  String get controlNumber => 'Control number';

  @override
  String get bloodType => 'Blood type';

  @override
  String get emergencyContact => 'Emergency contact';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get saveProfile => 'Save changes';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get activeAlerts => 'Active Alerts';

  @override
  String get noActiveAlerts => 'No active alerts';

  @override
  String get distance => 'Distance';

  @override
  String get elapsed => 'Ago';

  @override
  String get accept => 'Accept';

  @override
  String get accepting => 'Accepting...';

  @override
  String get accepted => 'Alert accepted';

  @override
  String get alertDetail => 'Alert Detail';

  @override
  String get studentInfo => 'Student Information';

  @override
  String get openChat => 'Open Chat';

  @override
  String get statusEnRoute => 'En route';

  @override
  String get statusAttending => 'Attending';

  @override
  String get statusResolved => 'Resolved';

  @override
  String get updateStatus => 'Update status';

  @override
  String get brigadistaProfile => 'Responder Profile';

  @override
  String get availability => 'Availability';

  @override
  String get onDuty => 'On duty';

  @override
  String get offDuty => 'Off duty';

  @override
  String get incidentsDashboard => 'Incidents Dashboard';

  @override
  String get filterByDate => 'Filter by date';

  @override
  String get filterByType => 'Filter by type';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get allIncidents => 'All';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get exportReport => 'Export report';

  @override
  String get userManagement => 'User Management';

  @override
  String get students => 'Students';

  @override
  String get brigadistas => 'First Responders';

  @override
  String get approve => 'Approve';

  @override
  String get block => 'Block';

  @override
  String get approved => 'Approved';

  @override
  String get blocked => 'Blocked';

  @override
  String get pending => 'Pending';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get logout => 'Sign out';

  @override
  String get logoutConfirm => 'Are you sure you want to sign out?';

  @override
  String get fallDetected => 'Possible fall detected';

  @override
  String get fallBody =>
      'If you are okay, press Cancel. Otherwise, an alert will be sent automatically.';

  @override
  String fallCountdown(int seconds) {
    return 'Sending alert in $seconds seconds...';
  }

  @override
  String get permissionLocationTitle => 'Location permission';

  @override
  String get permissionLocationBody =>
      'LIFETAP needs access to your location to share it with first responders in case of emergency.';

  @override
  String get permissionGranted => 'Permission granted';

  @override
  String get permissionDenied =>
      'Permission denied — some features won\'t be available';

  @override
  String get statusActive => 'Active';

  @override
  String get statusResolved2 => 'Resolved';

  @override
  String get statusPending => 'Pending';

  @override
  String get languageES => 'ES';

  @override
  String get languageEN => 'EN';

  @override
  String get language => 'Language';

  @override
  String get noInternetOffline => 'No connection — showing saved data';

  @override
  String get syncing => 'Syncing...';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get totalIncidents => 'Total incidents';

  @override
  String get activeNow => 'Active now';

  @override
  String get resolvedToday => 'Resolved today';
}
