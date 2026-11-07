import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Cola local de eventos que se sincronizan al recuperar conexión.
///
/// Fuente de verdad mientras no hay red. El sync worker procesa esta cola
/// llamando a `rpc_sync_queue_item` por cada item en orden cronológico.
///
/// Ver flujo en `03-diseno/diagrama-flujo-offline.svg`.
class OfflineQueue {
  static const _boxName = 'offline_queue';
  static const _uuid = Uuid();

  static Future<void> init() async {
    await Hive.openBox<String>(_boxName);
  }

  static Box<String> get _box => Hive.box<String>(_boxName);

  /// Agrega un item a la cola.
  static Future<String> enqueue({
    required String payloadType,
    required Map<String, dynamic> payload,
  }) async {
    final id = _uuid.v4();
    final item = QueueItem(
      id: id,
      payloadType: payloadType,
      payload: payload,
      tsDevice: DateTime.now().toUtc(),
      status: 'pending',
    );
    await _box.put(id, jsonEncode(item.toJson()));
    return id;
  }

  /// Lista todos los items pendientes ordenados por fecha de creación.
  static List<QueueItem> pendingItems() {
    return _box.values
        .map((s) => QueueItem.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .where((i) => i.status == 'pending' || i.status == 'failed')
        .toList()
      ..sort((a, b) => a.tsDevice.compareTo(b.tsDevice));
  }

  /// Marca un item como sincronizado y lo elimina.
  static Future<void> markSynced(String id) async {
    await _box.delete(id);
  }

  /// Marca un item como fallido (queda en cola para reintento).
  static Future<void> markFailed(String id, String error) async {
    final raw = _box.get(id);
    if (raw == null) return;
    final item = QueueItem.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    item.status = 'failed';
    item.attempts += 1;
    item.errorMessage = error;
    await _box.put(id, jsonEncode(item.toJson()));
  }

  /// Stream para escuchar cambios (UI muestra contador de pendientes).
  static Stream<int> pendingCountStream() {
    return _box.watch().map((_) => pendingItems().length).distinct();
  }

  static int get pendingCount => pendingItems().length;
}

class QueueItem {
  String id;
  String payloadType;        // 'shift_event' | 'incident'
  Map<String, dynamic> payload;
  DateTime tsDevice;
  String status;             // 'pending' | 'syncing' | 'failed'
  int attempts;
  String? errorMessage;

  QueueItem({
    required this.id,
    required this.payloadType,
    required this.payload,
    required this.tsDevice,
    this.status = 'pending',
    this.attempts = 0,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'payload_type': payloadType,
        'payload': payload,
        'ts_device': tsDevice.toIso8601String(),
        'status': status,
        'attempts': attempts,
        'error_message': errorMessage,
      };

  factory QueueItem.fromJson(Map<String, dynamic> j) => QueueItem(
        id: j['id'] as String,
        payloadType: j['payload_type'] as String,
        payload: Map<String, dynamic>.from(j['payload'] as Map),
        tsDevice: DateTime.parse(j['ts_device'] as String),
        status: j['status'] as String,
        attempts: j['attempts'] as int? ?? 0,
        errorMessage: j['error_message'] as String?,
      );
}
