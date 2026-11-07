import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'offline_queue.dart';

/// Worker que escucha cambios de conectividad y sincroniza la cola.
///
/// Ejecuta una pasada al recuperar la red y reintenta items en estado
/// 'failed' con backoff exponencial.
class SyncWorker {
  SyncWorker({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  StreamSubscription? _connSub;
  bool _running = false;

  void start() {
    _connSub = Connectivity().onConnectivityChanged.listen((results) {
      final hasNet = results.any((r) => r != ConnectivityResult.none);
      if (hasNet) _runOnce();
    });
  }

  void stop() {
    _connSub?.cancel();
    _connSub = null;
  }

  Future<void> _runOnce() async {
    if (_running) return;
    _running = true;
    try {
      final items = OfflineQueue.pendingItems();
      for (final item in items) {
        await _syncItem(item);
      }
    } finally {
      _running = false;
    }
  }

  Future<void> _syncItem(QueueItem item) async {
    try {
      // Backoff: si ya falló N veces, esperar
      final waitMs = 500 * (1 << item.attempts.clamp(0, 6));
      await Future<void>.delayed(Duration(milliseconds: waitMs));

      final rpcName = item.payload['event_type'] == 'check_in'
          ? 'rpc_create_check_in'
          : 'rpc_create_check_out';

      final result = await _client.rpc(rpcName, params: {
        'p_shift_id': item.payload['shift_id'],
        'p_lat': item.payload['lat'],
        'p_lng': item.payload['lng'],
        'p_accuracy_m': item.payload['accuracy_m'],
        'p_ts_device': item.payload['ts_device'],
        'p_tamper_flags': item.payload['tamper_flags'] ?? {},
      });

      final success = (result as Map)['success'] as bool? ?? false;
      if (success) {
        await OfflineQueue.markSynced(item.id);
      } else {
        await OfflineQueue.markFailed(item.id, (result['error'] as String?) ?? 'unknown');
      }
    } catch (e) {
      await OfflineQueue.markFailed(item.id, e.toString());
    }
  }
}
