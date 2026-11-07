import 'package:supabase_flutter/supabase_flutter.dart';

/// Wrapper tipado sobre las RPCs y queries del backend Supabase.
class SupabaseService {
  SupabaseService(this._client);
  final SupabaseClient _client;

  /// Verifica PIN del guardia. Devuelve mapa con success + datos.
  Future<Map<String, dynamic>> verifyPin({
    required String employeeCode,
    required String pin,
  }) async {
    final result = await _client.rpc('rpc_verify_pin', params: {
      'p_employee_code': employeeCode,
      'p_pin': pin,
    });
    return Map<String, dynamic>.from(result as Map);
  }

  /// Llama a rpc_create_check_in con todas las validaciones server-side.
  Future<Map<String, dynamic>> createCheckIn({
    required String shiftId,
    required Map<String, dynamic> locationPayload,
    Map<String, dynamic>? deviceInfo,
  }) async {
    final result = await _client.rpc('rpc_create_check_in', params: {
      'p_shift_id': shiftId,
      'p_lat': locationPayload['lat'],
      'p_lng': locationPayload['lng'],
      'p_accuracy_m': locationPayload['accuracy_m'],
      'p_ts_device': locationPayload['ts_device'],
      'p_tamper_flags': locationPayload['tamper_flags'],
      'p_device_info': deviceInfo,
    });
    return Map<String, dynamic>.from(result as Map);
  }

  /// Llama a rpc_create_check_out.
  Future<Map<String, dynamic>> createCheckOut({
    required String shiftId,
    required Map<String, dynamic> locationPayload,
    String? notes,
    Map<String, dynamic>? deviceInfo,
  }) async {
    final result = await _client.rpc('rpc_create_check_out', params: {
      'p_shift_id': shiftId,
      'p_lat': locationPayload['lat'],
      'p_lng': locationPayload['lng'],
      'p_accuracy_m': locationPayload['accuracy_m'],
      'p_ts_device': locationPayload['ts_device'],
      'p_notes': notes,
      'p_tamper_flags': locationPayload['tamper_flags'],
      'p_device_info': deviceInfo,
    });
    return Map<String, dynamic>.from(result as Map);
  }

  /// Obtiene el turno actual del guardia (programado o en curso para hoy).
  Future<Map<String, dynamic>?> getCurrentShift(String guardId) async {
    final today = DateTime.now().toUtc().toIso8601String().split('T').first;
    final rows = await _client
        .from('shifts')
        .select('*, locations(*)')
        .eq('guard_id', guardId)
        .or('status.eq.in_progress,scheduled_start.gte.$today')
        .order('scheduled_start', ascending: true)
        .limit(1);
    return rows.isEmpty ? null : Map<String, dynamic>.from(rows.first as Map);
  }
}
