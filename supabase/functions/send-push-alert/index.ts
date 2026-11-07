// ============================================================================
// Edge Function · send-push-alert
// ----------------------------------------------------------------------------
// Envía push notification vía FCM cuando hay un evento crítico:
//   - Tamper detectado en check-in
//   - Turno marcado como missed
//   - Incidente severidad >= 4
// ============================================================================
import { serve } from 'https://deno.land/std@0.224.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

interface PushPayload {
  user_id: string;
  type: string;
  title: string;
  body: string;
  data?: Record<string, unknown>;
}

const FCM_SERVER_KEY = Deno.env.get('FCM_SERVER_KEY')!;
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 });
  }

  const payload = (await req.json()) as PushPayload;
  const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

  // Resolver fcm_token del destinatario (guard o supervisor)
  const { data: guard } = await supabase
    .from('guards')
    .select('fcm_token, tenant_id')
    .eq('user_id', payload.user_id)
    .single();

  if (!guard?.fcm_token) {
    return new Response(JSON.stringify({ error: 'no_token' }), { status: 200 });
  }

  // Enviar a FCM
  const fcmResponse = await fetch('https://fcm.googleapis.com/fcm/send', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `key=${FCM_SERVER_KEY}`,
    },
    body: JSON.stringify({
      to: guard.fcm_token,
      notification: {
        title: payload.title,
        body: payload.body,
        sound: 'default',
        priority: 'high',
      },
      data: payload.data ?? {},
    }),
  });

  const fcmJson = await fcmResponse.json();

  // Registrar en tabla notifications
  await supabase.from('notifications').insert({
    tenant_id: guard.tenant_id,
    user_id: payload.user_id,
    type: payload.type,
    title: payload.title,
    body: payload.body,
    data: payload.data,
    fcm_message_id: fcmJson.message_id,
    delivered: fcmResponse.ok,
  });

  return new Response(JSON.stringify({ success: fcmResponse.ok }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
});
