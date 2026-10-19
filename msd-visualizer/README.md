# msd-visualizer — visualizador del flujo MSD (Fase 2, maqueta)

**Rol del proyecto:** preparar la fase de desarrollo con una herramienta visual del flujo de producto
(**sin auth/roles ni backend todavía**) usando los artefactos **reales** de la PoC de VectorCraft
(lote de 20 piezas generadas vía MCP, Fase 1).

## Stack

- Astro 7 (static) + islas Svelte 5 (runes) + Tailwind 4
- Datos reales de la PoC embebidos: `src/data/campaign-manifest.json`, `src/data/audit-log.jsonl`,
  previews en `public/demo/previews/` (copiados desde `../poc-vectorcraft/clients/client-001/...`)

## Pantallas (mapean el flujo ideal §3 del plan maestro)

| Ruta | Qué representa | Punto del flujo |
|---|---|---|
| `/` | Dashboard de flujo + resumen real de la campaña PoC | orientación general |
| `/campana` | Galería de las 20 piezas reales: filtros paleta/tema, detalle con stepper de estados (borrador→aprobado→exportado) y comentario "solicitar cambios" (mock del editor híbrido) | pasos 8–10 revisión/aprobación |
| `/brief` | Brand kit + canales + brief + **plan de contenidos simulado** (isla `BriefFlow.svelte`) | pasos 2–7 |
| `/manifiesto` | Visor del manifiesto §14.5 (partes, límite 80MiB, sha256) y de la bitácora `audit-log.jsonl` | trazabilidad |

## Desarrollo

```sh
npm run dev        # localhost:4321 (en este repo el AGENTS.md pide modo background:
                   #  astro dev --background / astro dev stop / status / logs)
npm run build      # verificación de compilación
```

## Reglas de maquetación (recordatorio para el equipo)

- `.astro` (JSX-like) = estático, sin estado interactivo → usar `map()` en el template.
- Cualquier interactividad (estado, filtros, steppers) = **isla Svelte** con `client:load`.
- El mock replica CONTRATOS, no pantallas decorativas: la galería ya consume la misma estructura
  (`parts[].items` + `exports[]` + hashes) que hablará el worker real de la plataforma.
- Los botones "solicitar cambios" y "avanzar estado" son locales a sesión; su integración real
  (cola de trabajos MCP + regeneración IA) es el siguiente hito.
