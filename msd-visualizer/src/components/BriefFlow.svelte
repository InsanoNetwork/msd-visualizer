<script lang="ts">
  const STEPS = ['Marca', 'Canales', 'Brief', 'Plan generado'] as const;

  let step = $state(0);
  let brandName = $state('Cafetería Amanecer');
  let palette = $state('amanecer');
  let tone = $state('cálido y cercano');
  let brandDesc = $state('Café de especialidad, tueste propio, ambiente acogedor y servicio rápido.');
  let channels = $state<string[]>(['feed', 'historias']);
  let pieceCount = $state(20);
  let briefText = $state(
    'Crea 20 piezas para promover mi cafetería este mes: oferta 2x1, lanzamiento de nuevo tueste y evento en tienda. Mantén el estilo cálido del brand kit.',
  );

  const CHANNEL_OPTS = [
    { id: 'feed', label: 'Feed 1080×1080' },
    { id: 'historias', label: 'Historias 1080×1920' },
    { id: 'whatsapp', label: 'Material WhatsApp' },
    { id: 'x', label: 'Publicación X' },
  ];

  const THEMES = ['Oferta de temporada', 'Nuevo producto', 'Evento en tienda', 'Testimonio cliente', 'Tip de la marca'];
  const PROMOS = ['2x1 hoy', 'pruébalo ya', 'te esperamos', '★★★★★', 'apúntate'];

  const plan = $derived(
    Array.from({ length: Math.min(pieceCount, 20) }, (_, i) => ({
      piece: i + 1,
      theme: THEMES[i % THEMES.length],
      promo: PROMOS[i % PROMOS.length],
      channel: CHANNEL_OPTS[(i % Math.max(channels.length, 1)) % CHANNEL_OPTS.length]?.id ?? 'feed',
    })),
  );

  function toggleChannel(id: string) {
    channels = channels.includes(id)
      ? channels.length > 1
        ? channels.filter((c) => c !== id)
        : channels
      : [...channels, id];
  }
</script>

<div class="mx-auto max-w-3xl">
  <h1 class="text-2xl font-semibold tracking-tight">Brief de campaña (maqueta)</h1>
  <p class="mt-1 text-sm text-neutral-400">
    Recorre los pasos 3–7 del flujo ideal. No hay backend: «generar» muestra el <em>plan de contenidos</em> que la IA
    propondría antes de dibujar las piezas con VectorCraft.
  </p>

  <!-- stepper navegación -->
  <div class="mt-6 mb-8 flex items-center gap-2">
    {#each STEPS as s, i}
      <button
        class="flex items-center gap-2 rounded-full px-3 py-1.5 text-xs {i <= step
          ? 'bg-amber-400 text-neutral-900'
          : 'bg-neutral-800 text-neutral-400'}"
        onclick={() => (step = i)}
      >
        <span class="font-semibold">{i + 1}</span> {s}
      </button>
      {#if i < STEPS.length - 1}
        <span class="h-px w-6 bg-neutral-700"></span>
      {/if}
    {/each}
  </div>

  {#if step === 0}
    <section class="space-y-4 rounded-xl border border-neutral-800 bg-neutral-900 p-6">
      <h2 class="font-medium">Identidad de la marca</h2>
      <label class="block text-sm">
        <span class="text-neutral-400">Nombre comercial</span>
        <input class="mt-1 w-full rounded-lg border border-neutral-700 bg-neutral-950 px-3 py-2" bind:value={brandName} />
      </label>
      <label class="block text-sm">
        <span class="text-neutral-400">Descripción</span>
        <textarea class="mt-1 h-20 w-full resize-none rounded-lg border border-neutral-700 bg-neutral-950 px-3 py-2" bind:value={brandDesc}></textarea>
      </label>
      <div class="grid grid-cols-2 gap-4">
        <label class="block text-sm">
          <span class="text-neutral-400">Paleta</span>
          <select class="mt-1 w-full rounded-lg border border-neutral-700 bg-neutral-950 px-3 py-2" bind:value={palette}>
            {#each ['amanecer', 'arandano', 'espresso', 'menta'] as p}
              <option value={p}>{p}</option>
            {/each}
          </select>
        </label>
        <label class="block text-sm">
          <span class="text-neutral-400">Tono</span>
          <input class="mt-1 w-full rounded-lg border border-neutral-700 bg-neutral-950 px-3 py-2" bind:value={tone} />
        </label>
      </div>
      <div class="flex justify-end">
        <button class="rounded-lg bg-amber-400 px-4 py-2 text-sm font-medium text-neutral-900" onclick={() => (step = 1)}>
          Siguiente: canales →
        </button>
      </div>
    </section>
  {:else if step === 1}
    <section class="space-y-4 rounded-xl border border-neutral-800 bg-neutral-900 p-6">
      <h2 class="font-medium">Canales y volumen</h2>
      <div class="flex flex-wrap gap-2">
        {#each CHANNEL_OPTS as c}
          <button
            class="rounded-full border px-3 py-1.5 text-sm {channels.includes(c.id)
              ? 'border-amber-400 bg-amber-400/10 text-amber-300'
              : 'border-neutral-700 text-neutral-400'}"
            onclick={() => toggleChannel(c.id)}
          >
            {c.label}
          </button>
        {/each}
      </div>
      <label class="block text-sm">
        <span class="text-neutral-400">Número de piezas: <strong class="text-neutral-100">{pieceCount}</strong> (MVP máx. 20)</span>
        <input type="range" min="1" max="20" bind:value={pieceCount} class="mt-2 w-full accent-amber-400" />
      </label>
      <div class="flex justify-between">
        <button class="text-sm text-neutral-400 hover:text-neutral-200" onclick={() => (step = 0)}>← Volver</button>
        <button class="rounded-lg bg-amber-400 px-4 py-2 text-sm font-medium text-neutral-900" onclick={() => (step = 2)}>
          Siguiente: brief →
        </button>
      </div>
    </section>
  {:else if step === 2}
    <section class="space-y-4 rounded-xl border border-neutral-800 bg-neutral-900 p-6">
      <h2 class="font-medium">Brief en lenguaje natural</h2>
      <textarea
        class="h-32 w-full resize-none rounded-lg border border-neutral-700 bg-neutral-950 px-3 py-3 text-sm"
        bind:value={briefText}
      ></textarea>
      <p class="text-xs text-neutral-500">
        En el MVP real, este brief viaja a la capa de servicios → agente IA → plan de contenidos → aprobación → lote vía MCP.
      </p>
      <div class="flex justify-between">
        <button class="text-sm text-neutral-400 hover:text-neutral-200" onclick={() => (step = 1)}>← Volver</button>
        <button
          class="rounded-lg bg-gradient-to-r from-amber-400 to-pink-500 px-4 py-2 text-sm font-semibold text-neutral-900"
          onclick={() => (step = 3)}
        >
          ✨ Generar plan (simulado)
        </button>
      </div>
    </section>
  {:else}
    <section class="rounded-xl border border-neutral-800 bg-neutral-900 p-6">
      <h2 class="font-medium">Plan de contenidos propuesto</h2>
      <p class="mt-1 text-xs text-neutral-500">
        {brandName} · paleta {palette} · tono {tone} · canales: {channels.join(', ')}
      </p>
      <div class="mt-4 max-h-96 overflow-auto rounded-lg border border-neutral-800">
        <table class="w-full text-sm">
          <thead class="sticky top-0 bg-neutral-950 text-left text-xs uppercase tracking-wider text-neutral-500">
            <tr>
              <th class="px-4 py-2">#</th>
              <th class="px-4 py-2">Tema</th>
              <th class="px-4 py-2">CTA</th>
              <th class="px-4 py-2">Canal</th>
            </tr>
          </thead>
          <tbody>
            {#each plan as p}
              <tr class="border-t border-neutral-800/60">
                <td class="px-4 py-1.5 text-neutral-400">{p.piece}</td>
                <td class="px-4 py-1.5">{p.theme}</td>
                <td class="px-4 py-1.5 text-amber-300">{p.promo}</td>
                <td class="px-4 py-1.5 text-neutral-400">{p.channel}</td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
      <p class="mt-3 text-xs text-neutral-500">
        Paso 7 del flujo: aquí el usuario aprobaría el plan antes de la generación real del lote vía MCP de VectorCraft.
      </p>
      <div class="mt-4 flex justify-between">
        <button class="text-sm text-neutral-400 hover:text-neutral-200" onclick={() => (step = 2)}>← Editar brief</button>
        <a href="/campana" class="rounded-lg border border-amber-400 px-4 py-2 text-sm text-amber-300 hover:bg-amber-400/10">
          Ver las 20 piezas reales generadas →
        </a>
      </div>
    </section>
  {/if}
</div>
