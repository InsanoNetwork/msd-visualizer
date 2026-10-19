# PoC VectorCraft MCP — Resultados y registro de avance

> Proyecto: plataforma híbrida de marketing digital con IA (`plan_plataforma_marketing_ia (1).md`)
> Opción de avance elegida: **Fase 1 — Factibilidad (PoC de VectorCraft MCP)**
> Fecha: 18–19 de octubre de 2026 · Estación de trabajo Windows (estación local, con GPU)

## Enfoque de trabajo

Desarrollo por fases y pasos. Esta carpeta contiene las pruebas de la Fase 1
cada script es reproducible (`scripts/*.cmd`) y cada resultado queda en `results/`.
La lista de tareas (badge ✅/⬜) se actualiza conforme avanza.

## Entorno detectado y verificado

| Ítem | Estado |
|---|---|
| VectorCraft desktop | ✅ Instalado en `C:\Program Files\VectorCraft\` |
| `vectorcraft-cli.exe` | ✅ Versión **0.3.1** (no está en PATH; se usa ruta absoluta) |
| Modos del CLI | `mcp` (JSON-RPC stdio), `run` (batch headless), `convert`, `info`, `bench`, `perf` |
| Formatos de lectura | `.vectorcraft/.drawcraft/.svg/.svgz/.pdf/.ai/.ait/.png/.jpg/.webp/.tif/.bmp/.eps/.dxf/.emf/.wmf` |

## Resultados funcionales

| # | Prueba | Comando | Resultado | Artefacto |
|---|--------|---------|-----------|-----------|
| 1 | Headless básico: doc 1080×1080 + rectángulo + elipse + texto | `run` (`file.new`, `shape.rectangle`, `shape.ellipse`, `text.create`) | ✅ PNG correcto, texto renderiza | `test1_headless.png` |
| 2 | Round-trip: guardar `.vectorcraft` → reabrir → editar color y texto → reexportar | `document.save`, `document.open` (via `run --in`), `paint.setFill {ids}`, `text.setText` | ✅ Sin pérdida de capas; edición selectiva por `id` funciona | `roundtrip*.vectorcraft`, `roundtrip_edited.png` |
| 3 | Logo con shapes + incrustación en otra pieza (`file.place`) | `file.place` con PNG | ✅ Imagen vincula (`linked: true`); SVG exportable | `logo_prueba.*`, `pieza_logo.*` |
| 4 | Export dual PNG + SVG | `--export` dos veces | ✅ Ambos formatos; SVG con imagen embebida/enlazada | `pieza_logo.svg` |
| 5 | Lote de 5 piezas secuenciales | bucle batch | ✅ 5/5 sin errores | `lote_piece_01..05.png` |
| 6 | Servidor MCP real (stdio JSON-RPC) | `mcp --headless` con mensajes de prueba (`test5_mcp_input.jsonl`) | ✅ 25 herramientas disponibles; sesión íntegra; export funcionando | `mcp_test.png` |
| 7 | Benchmarks del motor | `bench`, `perf` | ✅ Para tamaño real: 8.8 ms/frame render, save 84 ms, SVG 371 ms (/todo el texto "OVER" del `perf` corresponde a un doc sintético de 50 mil paths, no a piezas reales) | — |

## Rendimiento medido (clave para escalado a 20 piezas)

- Generación de 1 pieza (1080×1080, ~5 objetos): **~75–170 ms** headless
- Lote de 5 piezas: **372 ms** total (incluye arranque de proceso por pieza)
- Extrapolación a lote de 20: **~1.5–2 s** de CPU (sin IO ni bloqueo de UI)

## Hallazgos técnicos importantes

1. **Nombres de comandos**: las herramientas MCP (`draw_shape`, `add_text`…) difieren de los comandos del motor (`shape.rectangle`, `text.create`…). En headless vía `run` se usan comandos del motor; en MCP directamente las tools. Catálogo: `vectorcraft-cli commands` (659 comandos; copia en `scripts/commands_catalog.json`).
2. **Paths en JSON**: dentro de `--params` JSON, las rutas **deben usar `/`** (el `\` de Windows es escape inválido). En `--export` (no JSON) va bien con `\`.
3. **PowerShell 5.1** destroza las comillas anidadas al llamar EXEs: usar archivos `.cmd` con `""` escapado en el batch. Los scripts aquí lo contienen.
4. **`file.place` vincula la imagen** (`linked: true`), no la embebe por defecto — revisar `link:` param y comportamiento al mover la carpeta para aislamiento por cliente. **Pendiente probar `includeLinked`/embed al guardar.**
5. **Fuente persistente**: texto guarda familia `Source Sans 3` y sobrevive al round-trip. Fuentes con licencia quedan en riesgo si se exportan a formatos que embedean — revisar por fuente.
6. **Aislamiento**: los flags `--automation-read-root/--automation-write-root` confinan el acceso del agente a carpetas —base del multi-tenant. Configurados en `opencode.json` limitando a `poc-vectorcraft/`.
7. **MCP sin progreso/cancelación asíncrona**: las llamadas export son síncronas — encaja bien con cola de jobs simple del diseño.

## Lista de tareas (actualizada conforme avanza) — Fase 1

- ✅ PASO 1: Verificar instalación del CLI (headless disponible)
- ✅ PASO 2: Formas + colores headless → PNG
- ✅ PASO 3: Texto headless renderiza (fuente sistema)
- ⬜ PASO 3b: Tipografías licencia / propios del cliente — cargar fuente custom y verificar
- ✅ PASO 4: Incrustar imagen (logo) en pieza
- ✅ PASO 5: Round-trip editable (formato `.vectorcraft`)
- ✅ PASO 6: Flujo prompt→pieza completo con estilo coherente (`test6_prompt_flujo.cmd`, póster "Cafetería Amanecer")
- ✅ PASO 7: Medición de tiempos 1 pieza + lote 5 (~75-170 ms/pieza; lote 5 = 372 ms)
- ✅ PASO 7b: **Lote 20 piezas con manifiesto y bitácora ✅ VALIDADO** — campaña completa `client-001/campaign-001` vía MCP: 1 doc `.vectorcraft` (647 KB, 0.77% del límite 80MiB, §14.5), 20 artboards nombradas, 20 PNG finales (1080×1080) + 20 previews (270px), `campaign-manifest.json` con sha256 de design+exports, `audit-log.jsonl` con 8 eventos trazables. Dibujo de las 20 piezas: **389 ms**; ciclo completo ~9 s.
- ✅ PASO 8: Puente **OpenCode ↔ MCP** ✅ VALIDADO (formato V2 `mcp.servers`; 25 tools; pieza end-to-end generada desde el agente: `mcp_opencode_pieza.png/svg/.vectorcraft`; nota: CLI 0.3.1 sin raíles de aislamiento)
- ✅ PASO 9: Lote con variaciones de misma plantilla ✅ VALIDADO — **campaign-002 "El Búho Nocturno"**: brief real del usuario (búho 🦉, morados, nocturno, cena coreana/asiática) → 4 cards feed con **logo búho arriba-izquierda** repetido y promo uniforme `$120 · 2×1 los lunes después de las 10 pm`. 1 doc (349 KB, 0.43% límite), 4 artboards, PNG + previews + manifest v1 + audit-log. **Hangul 월요일 renderiza** con `font: "Malgun Gothic"`. Dibujado directo desde el agente vía Code Mode (`tools.vectorcraft.*`), iteración visual v1→v2 (baselines de texto en chip, kicker/titular). 
- ⬜ PASO 10: Aislamiento multi-tenant — raíces por cliente y pruebas de escape
- ✅ PASO 11: Validar textos es-ES (acentos/ñ): vía MCP stdio UTF-8 ✅ ("Café" perfecto); vía batch `.cmd` ❌ (ASCII only, no es la vía del producto)
- ⬜ PASO 12: Abrir `.vectorcraft` generado en la app de escritorio (híbrido: edición manual)

## Pendiente de decisión técnica (para el siguiente paso)

- Elegir **modo integration**: `vectorcraft-cli run` (proceso por pieza) vs `mcp` headless persistente vs `mcp --connect 127.0.0.1:7979` (app visible). Recomendación preliminar: `run`/headless para worker, con app visible para iterar manual en PoC.
- Definir **schema del manifiesto de campaña** (partes, assets, hash) y probar particionamiento real con doc grande.
- Definir flujo **estándar de pieza**: template `.vctemplate` vs generación desde 0 con primitives.

## Cómo reproducir

```sh
cd poc-vectorcraft\scripts
test1_headless.cmd        # pieza básica
test2_roundtrip.cmd       # round-trip editable
test3_imagen_svg.cmd      # logo + imagen incrustada + SVG
test4_batch5.cmd          # lote de 5 piezas
test5_mcp.cmd             # serv reador MCP con JSON-RPC
```
