# panel-admin · Next.js 14

Panel administrativo de control de operación.

## Stack
- Next.js 14 (App Router)
- TypeScript estricto
- Tailwind CSS + shadcn/ui (radix)
- Supabase (@supabase/ssr)
- TanStack Query · Zustand
- Mapbox GL · Recharts

## Setup local

```bash
cp ../.env.example .env.local
# editar .env.local

npm install
npm run dev
# → http://localhost:3000
```

## Scripts

| Comando | Propósito |
|---|---|
| `npm run dev` | Servidor de desarrollo |
| `npm run build` | Build de producción |
| `npm run start` | Servir build |
| `npm run lint` | ESLint |
| `npm run type-check` | TypeScript (no emite) |
| `npm run test` | Vitest unit tests |
| `npm run test:e2e` | Playwright E2E |

## Estructura

```
src/
├── app/
│   ├── layout.tsx, page.tsx, globals.css
│   ├── (auth)/login/page.tsx
│   └── (dashboard)/
│       ├── dashboard/      # tablero presencia (default)
│       ├── guardias/       # CRUD guardias
│       ├── ubicaciones/    # CRUD ubicaciones + mapa
│       ├── turnos/         # programación de turnos
│       ├── bitacora/       # incidencias del tenant
│       └── reportes/       # exports Excel
├── components/{ui,features}/
├── lib/{supabase,utils,hooks}/
├── styles/
└── middleware.ts
```

## Despliegue

Vercel: push a `main` → preview en PR, `main` → prod.
Configurar env vars en Vercel dashboard (idéntico a `.env.local`).
