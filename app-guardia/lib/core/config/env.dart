import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Acceso tipado a variables de entorno.
class Env {
  static String get supabaseUrl => _get('SUPABASE_URL_FLUTTER');
  static String get supabaseAnonKey => _get('SUPABASE_ANON_KEY_FLUTTER');
  static String get sentryDsn => _get('SENTRY_DSN_FLUTTER', required: false);
  static String get fcmSenderId => _get('FCM_SENDER_ID', required: false);
  static String get environment =>
      _get('ENVIRONMENT', required: false, fallback: 'dev');
  static String get defaultTenantId => _get('DEFAULT_TENANT_ID');

  static String _get(String key, {bool required = true, String fallback = ''}) {
    final value = dotenv.env[key] ?? fallback;
    if (value.isEmpty && required) {
      throw StateError('Missing required env var: $key');
    }
    return value;
  }
}
