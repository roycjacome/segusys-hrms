#!/usr/bin/env bash
# ============================================================================
# Bootstrap del entorno de desarrollo · Sistema Segusys
# ----------------------------------------------------------------------------
# Verifica dependencias e instala/configura los 3 workspaces.
# Uso: bash scripts/setup-dev.sh
# ============================================================================
set -euo pipefail

cd "$(dirname "$0")/.."

echo "▸ Verificando dependencias..."
command -v node >/dev/null    || { echo "❌ Falta node ≥ 20"; exit 1; }
command -v flutter >/dev/null || { echo "❌ Falta flutter ≥ 3.19"; exit 1; }
command -v supabase >/dev/null || { echo "❌ Falta supabase CLI (npm i -g supabase)"; exit 1; }

if [ ! -f .env ]; then
  echo "▸ Copiando .env.example → .env (edítalo con tus claves antes de continuar)"
  cp .env.example .env
fi

echo "▸ Panel admin (Next.js)..."
( cd panel-admin && npm install )

echo "▸ App guardia (Flutter)..."
( cd app-guardia && flutter pub get )

echo "▸ Supabase local..."
( cd supabase && supabase start )

echo "✅ Entorno listo. Próximos pasos:"
echo "   - panel-admin: npm run dev    →  http://localhost:3000"
echo "   - app-guardia: flutter run    →  device/simulador"
echo "   - supabase:    supabase status"
