import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => _get('SUPABASE_URL_ADMIN_CLIENTE', fallback: _get('SUPABASE_URL_FLUTTER', required: false));
  static String get supabaseAnonKey => _get('SUPABASE_ANON_KEY_ADMIN_CLIENTE', fallback: _get('SUPABASE_ANON_KEY_FLUTTER', required: false));
  static String get sentryDsn => _get('SENTRY_DSN_ADMIN_CLIENTE', required: false);
  static String get environment => _get('ENVIRONMENT', required: false, fallback: 'dev');
  static bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static String _get(String key, {bool required = true, String fallback = ''}) {
    final value = dotenv.env[key] ?? fallback;
    if (value.isEmpty && required) {
      throw StateError('Missing required env var: $key');
    }
    return value;
  }
}
