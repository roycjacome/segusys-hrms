'use server';

import { revalidatePath } from 'next/cache';
import { createClient } from '@/lib/supabase/server';

function hasSupabaseEnv() {
  return Boolean(process.env.NEXT_PUBLIC_SUPABASE_URL && process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);
}

function readText(formData: FormData, key: string) {
  return String(formData.get(key) ?? '').trim();
}

function readNumber(formData: FormData, key: string, fallback: number) {
  const value = Number(formData.get(key));
  return Number.isFinite(value) ? value : fallback;
}

export async function createLocationAction(formData: FormData) {
  if (!hasSupabaseEnv()) {
    revalidatePath('/dashboard/ubicaciones');
    return;
  }

  const tenantId = process.env.DEFAULT_TENANT_ID ?? readText(formData, 'tenant_id');
  const name = readText(formData, 'name');
  const clientName = readText(formData, 'client_name');
  const address = readText(formData, 'address');
  const city = readText(formData, 'city');
  const state = readText(formData, 'state');
  const lat = readNumber(formData, 'lat', 19.4326);
  const lng = readNumber(formData, 'lng', -99.1332);
  const geofenceRadius = readNumber(formData, 'geofence_radius_m', 50);

  if (!tenantId || !name) {
    revalidatePath('/dashboard/ubicaciones');
    return;
  }

  const supabase = createClient();
  await supabase.from('locations').insert({
    tenant_id: tenantId,
    name,
    client_name: clientName || null,
    address: address || null,
    city: city || null,
    state: state || null,
    geofence_radius_m: geofenceRadius,
    geo: `POINT(${lng} ${lat})`,
  });

  revalidatePath('/dashboard/ubicaciones');
  revalidatePath('/dashboard');
}
