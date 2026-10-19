<script lang="ts">
  import { PIECE_STATES, PALETTE_COLORS, type PieceState } from '../lib/campaignStates';

  export interface GalleryPiece {
    pieceId: string;
    artboard: number;
    channel: string;
    formatSize: string;
    palette: string;
    theme: string;
    imageUrl: string;
    fileSize: number;
  }

  let { pieces }: { pieces: GalleryPiece[] } = $props();

  let paletteFilter = $state<string>('todas');
  let themeFilter = $state<string>('todos');
  let selected = $state<GalleryPiece | null>(null);
  let states = $state<Record<string, PieceState>>({});
  let comments = $state<Record<string, string>>({});

  const palettes = ['todas', ...Object.keys(PALETTE_COLORS)];
  const themes = ['todos', ...new Set(pieces.map((p) => p.theme))];

  const filtered = $derived(
    pieces.filter(
      (p) =>
        (paletteFilter === 'todas' || p.palette === paletteFilter) &&
        (themeFilter === 'todos' || p.theme === themeFilter),
    ),
  );

  function stateOf(pieceId: string): PieceState {
    return states[pieceId] ?? 'borrador';
  }

  function advance(pieceId: string) {
    const i = PIECE_STATES.indexOf(stateOf(pieceId));
    if (i < PIECE_STATES.length - 1) {
      states = { ...states, [pieceId]: PIECE_STATES[i + 1] };
    }
  }

  function resetAll() {
    states = {};
    comments = {};
  }

  function requestChanges(pieceId: string) {
    states = { ...states, [pieceId]: 'cambios solicitados' };
  }

  const fmt = (n: number) => (n / 1024).toFixed(1) + ' KB';
</script>

<!-- filtros -->
<div class="mb-6 flex flex-wrap items-center gap-2">
  <span class="text-xs uppercase tracking-wider text-neutral-500">Paleta</span>
  {#each palettes as pf}
    <button
      class="rounded-full border px-3 py-1 text-xs transition-colors {paletteFilter === pf
        ? 'border-amber-400 bg-amber-400/10 text-amber-300'
        : 'border-neutral-700 text-neutral-400 hover:border-neutral-500'}"
      onclick={() => (paletteFilter = pf)}
    >
      {pf === 'todas' ? 'Todas' : (PALETTE_COLORS[pf]?.label ?? pf)}
    </button>
  {/each}
  <span class="ml-3 text-xs uppercase tracking-wider text-neutral-500">Tema</span>
  {#each themes as tf}
    <button
      class="rounded-full border px-3 py-1 text-xs transition-colors {themeFilter === tf
        ? 'border-pink-400 bg-pink-400/10 text-pink-300'
        : 'border-neutral-700 text-neutral-400 hover:border-neutral-500'}"
      onclick={() => (themeFilter = tf)}
    >
      {tf === 'todos' ? 'Todos' : tf}
    </button>
  {/each}
  <span class="ml-auto text-xs text-neutral-500">{filtered.length} / {pieces.length} piezas</span>
  <button
    class="rounded-md border border-neutral-700 px-3 py-1 text-xs text-neutral-400 hover:border-neutral-500 hover:text-neutral-200"
    onclick={resetAll}>Reiniciar estados</button
  >
</div>

<!-- grid -->
<div class="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-5">
  {#each filtered as p (p.pieceId)}
    <button
      class="group relative overflow-hidden rounded-xl border border-neutral-800 bg-neutral-900 transition hover:border-amber-400/60"
      onclick={() => (selected = p)}
    >
      <img
        src={p.imageUrl}
        alt={p.pieceId}
        class="aspect-square w-full object-cover transition group-hover:scale-[1.02]"
        loading="lazy"
      />
      <div class="absolute top-2 left-2 rounded-md bg-black/70 px-2 py-0.5 text-[10px] font-medium text-neutral-300">
        {p.pieceId.replace('piece-', '#')}
      </div>
      <div class="absolute bottom-0 w-full bg-gradient-to-t from-black/80 to-transparent p-2 text-left">
        <div class="truncate text-xs text-neutral-200">{p.theme}</div>
        <div class="flex items-center gap-1.5 text-[10px] text-neutral-400">
          <span class="inline-block size-2 rounded-full" style="background: {PALETTE_COLORS[p.palette]?.bg ?? '#888'}"></span>
          {p.palette} · <span class="state-badge">{stateOf(p.pieceId)}</span>
        </div>
      </div>
    </button>
  {/each}
</div>

<!-- modal detalle -->
{#if selected}
  <div
    class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 p-4 backdrop-blur-sm"
    role="dialog"
    aria-modal="true"
  >
    <div class="max-h-[92vh] w-full max-w-5xl overflow-auto rounded-2xl border border-neutral-800 bg-neutral-900">
      <div class="grid gap-6 md:grid-cols-2">
        <div class="p-6">
          <img src={selected.imageUrl} alt={selected.pieceId} class="w-full rounded-xl border border-neutral-800" />
        </div>
        <div class="p-6 md:pl-0">
          <div class="flex items-start justify-between">
            <div>
              <h2 class="text-xl font-semibold">{selected.theme}</h2>
              <p class="text-sm text-neutral-400">{selected.pieceId.replace('piece-', 'Pieza #')} · artboard {selected.artboard}</p>
            </div>
            <button
              class="rounded-md border border-neutral-700 px-2 py-1 text-xs text-neutral-400 hover:text-neutral-100"
              onclick={() => (selected = null)}
              >cerrar ✕</button
            >
          </div>

          <dl class="mt-4 grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
            <dt class="text-neutral-500">Canal</dt>
            <dd>{selected.channel}</dd>
            <dt class="text-neutral-500">Formato</dt>
            <dd>{selected.formatSize}</dd>
            <dt class="text-neutral-500">Paleta</dt>
            <dd class="flex items-center gap-2">
              <span class="inline-block size-3 rounded" style="background: {PALETTE_COLORS[selected.palette]?.bg ?? '#888'}"></span>
              {PALETTE_COLORS[selected.palette]?.label ?? selected.palette}
            </dd>
            <dt class="text-neutral-500">Archivo export</dt>
            <dd class="truncate text-neutral-300">{selected.exportPath.split('/').pop()}</dd>
            <dt class="text-neutral-500">Tamaño</dt>
            <dd>{fmt(selected.fileSize)}</dd>
          </dl>

          <!-- stepper de estados -->
          <div class="mt-6">
            <h3 class="mb-2 text-xs font-semibold uppercase tracking-wider text-neutral-500">Estado de aprobación</h3>
            <div class="flex flex-wrap gap-1.5">
              {#each PIECE_STATES as st, i}
                <span
                  class="rounded-full px-2.5 py-1 text-[11px] {PIECE_STATES.indexOf(stateOf(selected.pieceId)) >= i
                    ? 'bg-emerald-500/15 text-emerald-300'
                    : 'bg-neutral-800 text-neutral-500'}"
                >
                  {st}
                </span>
              {/each}
            </div>
          </div>

          <!-- comentarios -->
          <div class="mt-6">
            <h3 class="mb-2 text-xs font-semibold uppercase tracking-wider text-neutral-500">Solicitar cambios (mock híbrido)</h3>
            <textarea
              class="h-20 w-full resize-none rounded-lg border border-neutral-700 bg-neutral-950 p-3 text-sm placeholder:text-neutral-600"
              placeholder="En lenguaje natural: «cambia el título a…» (solo maqueta)"
              bind:value={comments[selected.pieceId]}
            ></textarea>
            <div class="mt-3 flex flex-wrap gap-2">
              <button
                class="rounded-md bg-amber-400 px-3 py-1.5 text-xs font-medium text-neutral-900 hover:bg-amber-300"
                onclick={() => advance(selected!.pieceId)}
              >
                → Avanzar estado
              </button>
              <button
                class="rounded-md border border-pink-500/60 px-3 py-1.5 text-xs text-pink-300 hover:bg-pink-500/10"
                onclick={() => requestChanges(selected!.pieceId)}
              >
                Solicitar cambios
              </button>
            </div>
            <p class="mt-3 text-[11px] leading-relaxed text-neutral-500">
              Los estados y el comentario son locales a la sesión (maqueta). En el MVP real se conectan con la cola de
              trabajos y la regeneración por IA vía MCP.
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
{/if}

<style>
  .state-badge {
    background: rgba(255, 255, 255, 0.12);
    border-radius: 9999px;
    padding: 1px 6px;
    color: #e5e5e5;
  }
</style>
