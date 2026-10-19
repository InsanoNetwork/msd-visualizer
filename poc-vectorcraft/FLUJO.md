# Ruta del flujo: prompt → pieza de marketing (Fase 1)

> Objetivo del flujo: que el usuario **escriba un prompt** ("crea 20 piezas para mi cafetería") y la plataforma genere y exporte piezas editables.
> Este documento define el camino técnico paso a paso y qué se ha validado ya.

## Diagrama general (estado Fase 1, validado con excepción del paso 4)

```text
(1) Usuario escribe prompt en el chat de la plataforma (o directamente en OpenCode en esta fase)
    "Crea un póster 1080x1080 para Cafetería Amanecer, estilo cálido, exporta PNG"
       |
       v
(2) Agente de IA (OpenCode) interpreta el brief
    - descompone en operaciones de diseño concretas
    - decide paleta, layout, jerarquía tipográfica, recursos
       |
       v
(3) Agente llama herramientas MCP de VectorCraft  (JSON-RPC over stdio, UTF-8)
    cliente MCP  ──│ tools/call: file.new 1080x1080          ──►  servidor MCP (mcp --headless)
                   │ tools/call: draw_shape (fondo)                    │
                   │ tools/call: draw_path   (taza/asas)               ──►  engine en-proceso
                   │ tools/call: add_text    (títulos)                        (mismo motor que la
                   │ tools/call: set_paint   (paleta)                          app de escritorio)
                   │ tools/call: screenshot  (auto-verificación visual)
                   │ tools/call: export     (PNG/SVG)
                   ▼
(4) Archivos resultantes en disco (write-root confinado)
    results/flujo_poster_amanecer.png            ← pieza final para entrega/red social
    results/flujo_poster_amanecer.svg            ← editable/escalable
    results/flujo_poster_amanecer.vectorcraft    ← ORIGINAL EDITABLE (documento nativo JSON)
       |
       v
(5) Auto-supervisión: el agente puede leer el PNG y verificar el diseño, iterar si falla
       |
       v
(6) Entrega: el usuario recibe piezas; puede abrir el .vectorcraft en la app de escritorio
    y seguir editando a mano (experiencia híbrida)
```

## Solución de conexión MCP (el eslabón que faltaba)

> ✅ **VALIDADO 19-oct-2026**: OpenCode carga el server con formato **V2** `mcp.servers` en `opencode.json`.
> Lecciones: (1) el formato V1 (`mcp.vectorcraft`) se ignora silenciosamente; (2) el CLI instalado **0.3.1 no soporta** `--automation-read-root/--automation-write-root` (bdzg existente en el repo v0.13.1) → servidor sin raíles en PoC; añadir raíles requiere compilar el CLI del repo o actualizar release; (3) verificar con `opencode mcp list` y `/mcps`.

| Modo | Comando | Cuándo usarlo | Estado |
|---|---|---|---|
| **A. Headless** | `vectorcraft-cli.exe mcp --headless --automation-read-root <dir> --automation-write-root <dir>` | Workeroco de generación en fondo de la plataforma; nunca muestra ventana. Es **el modo elegido**. | ✅ Validado por JSON-RPC manual |
| **B. App visible** | `vectorcraft --control 7979` + `mcp --connect 127.0.0.1:7979` | Depuración/iteración manual: ves el documento cambiar en vivo. | ⬜ Opcional, no crítico |

La conexión OpenCode ↔ MCP se define en `opencode.json` (raíz del proyecto):

```json
"vectorcraft": {
  "type": "local",
  "command": ["C:\\Program Files\\VectorCraft\\vectorcraft-cli.exe", "mcp",
              "--headless",
              "--automation-read-root", "<carpeta del proyecto/cliente>",
              "--automation-write-root", "<carpeta results del cliente>"]
}
```

- OpenCode arranca el servidor MCP al iniciar la sesión (stdio; no ocupa puertos).
- Raíles `--automation-read-root/--automation-write-root`: el agente NO puede leer/escribir fuera de esas carpetas → **base técnico del aislamiento multi-tenant** (1 raíz de lectura/escritura por cliente).
- El repo local (v0.13.1) y el binario instalado (CLI 0.3.1) comparten conexión idéntica; no hace falta compilar el repo para esta fase.

## Vocabulario: 2 idiomas, 1 motor  ⚠

| Herramienta MCP (agente) | Comando motor (CLI `run --cmd`) | Nota |
|---|---|---|
| `draw_shape` | `shape.rectangle`, `shape.ellipse`… | params difieren (cx/cy vs x,y,w,h) |
| `draw_path` | `path.create` | `d` SVG idéntico |
| `add_text` | `text.create` | MCP añade `fit`, `justify` |
| `set_paint` | `paint.setFill` / `paint.setStroke` | |
| `open_file`/`save_file`/`export` | `document.open`/`document.save`/`document.export` | |
| `run_command` | — | escape a cualquier comando de los ~710 del catálogo |

Catálogo completo: `vectorcraft-cli commands` (copia en `scripts/commands_catalog.json`, 659 cmds).

## Hallazgos de codificación (crítico para español) ⚠

| Vía | Texto con acentos | Veredicto |
|---|---|---|
| **MCP stdio (JSON-RPC)** | `Café`, `ñ`, `á…` ✅ | ✅ **Vía del producto**: UTF-8 pasa intacto (probado) |
| Batch `.cmd` (PowerShell/cmd spawn) | `é` → `®` ❌ | ⚠ Solo para PoC: ASCII puro |
| PowerShell inline | comillas destrozadas ❌ | ⚠ usar archivos .cmd, nunca inline |

## Pasos del flujo Fase 1: estado

| Paso | Descripción | Estado |
|---|---|---|
| 1 | Prompt del usuario (fase 1: en OpenCode; fase plataforma: chat en Astro) | ✅ simulado |
| 2 | Prompt→operaciones de diseño (el "cerebro" del agente) | ✅ mano a mano |
| 3 | Herramientas MCP → engine headless → archivos | ✅ validado por JSON-RPC manual (`test5_mcp.cmd`) |
| 3b | **Cliente MCP real = OpenCode** cargando el server | ✅ **VALIDADO** — `opencode.json` con formato V2 (`mcp.servers`); 25 tools `tools.vectorcraft.*` disponibles; pieza generada end-to-end (`mcp_opencode_pieza.png/.svg/.vectorcraft`) con acentos perfectos |
| 4 | Archivos en results (PNG/SVG/.vectorcraft) | ✅ |
| 5 | Auto-verificación del agente (leer PNG, iterar) | ✅ extensa vía pruebas |
| 6 | Apertura del .vectorcraft en desktop app (edición híbrida manual) | ⬜ falta probar apertura manual del archivo |

## Qué falta para cerrar Fase 1 (bloqueado por acción humana ligera)

1. **Reiniciar la sesión de OpenCode** → carga `opencode.json` → el agente tendrá tools `mcp__vectorcraft__*` nativas → generar una pieza hablándole (validate el paso 3b=real).
2. Probar apertura del `.vectorcraft` en la app de escritorio (doble clic en `results/flujo_poster_amanecer.vectorcraft`).
3. (Opcional) Lote 20 piezas con manifiesto + bitácora.
4. (Opcional) Prueba de aislamiento: raíles por-tenant y escape fuera de las raíces.

## Próximo hito (Fase 2 o directa): mismos pasos 1-6 dentro de Astro SSR

Calco del flujo arriba reemplazando OpenCode-faceless:
- día a día: ASTRO UI (chat simple) → capa servicios TS → llamada a `vectorcraft-cli mcp` como proceso hijo via stdio JSON-RPC (mismo protocolo, ya validado) → cola de trabajos → vista previa → descarga.
Es decir: **el protocolo probado aquí es EL MISMO protocolo que la plataforma hablará con su worker**. La PoC de la Fase 1 apoya directamente el diseño del worker de la Fase 3.
