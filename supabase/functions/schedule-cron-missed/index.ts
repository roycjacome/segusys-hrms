// ============================================================================
// Edge Function · schedule-cron-missed
// ----------------------------------------------------------------------------
// Cron diario que marca como `missed` los turnos que ya pasaron
// el tiempo de gracia (scheduled_start + 30min) sin check-in.
//
// Configurar en Supabase Cron:
//   0 */1 * * *  →  https://<proj>.supabase.co/functions/v1/schedule-cron-missed
// ============================================================================
import { serve } from 'https://deno.land/std@0.224.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

serve(async () => {
  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

  // Marcar como missed los scheduled cuya ventana ya cerró
  const { data: missed, error } = await supabase.rpc('exec_sql', {
    sql: `
      WITH updated AS (
        UPDATE shifts
           SET status = 'missed'
         WHERE status = 'scheduled'
           AND scheduled_start + interval '30 min' < now()
        RETURNING id, guard_id, location_id, tenant_id
      )
      SELECT * FROM updated;
    `,
  });

  if (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 });
  }

  // Para cada turno missed, notificar al supervisor (TODO: resolver supervisor_id)
  for (const shift of (missed as any[]) ?? []) {
    // Llamar a send-push-alert
    await fetch(`${SUPABASE_URL}/functions/v1/send-push-alert`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${SERVICE_ROLE_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        user_id: shift.guard_id, // TODO cambiar por supervisor_id
        type: 'shift_missed',
        title: 'Turno no iniciado',
        body: `Turno ${shift.id} sin check-in.`,
        data: { shift_id: shift.id },
      }),
    });
  }

  return new Response(
    JSON.stringify({ marked_missed: (missed as any[])?.length ?? 0 }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
});
