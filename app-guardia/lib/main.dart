// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'data/offline/offline_queue.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Cargar variables de entorno
  await dotenv.load(fileName: '.env');

  // 2. Inicializar Hive (offline storage)
  await Hive.initFlutter();
  await OfflineQueue.init();

  // 3. Inicializar Supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    debug: false,
  );

  // 4. Inicializar Firebase (FCM)
  await Firebase.initializeApp();

  // 5. Inicializar Sentry y arrancar app
  await SentryFlutter.init(
    (options) {
      options.dsn = Env.sentryDsn;
      options.tracesSampleRate = 0.2;
      options.environment = Env.environment;
    },
    appRunner: () => runApp(
      const ProviderScope(child: SegusysApp()),
    ),
  );
}
