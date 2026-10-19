// Módulo client-safe: sin dependencias de node:fs (lo usan componentes Svelte)
export const PIECE_STATES = [
  'borrador',
  'en revisión',
  'cambios solicitados',
  'aprobado',
  'exportado',
] as const;

export type PieceState = (typeof PIECE_STATES)[number];

export const PALETTE_COLORS: Record<string, { bg: string; ring: string; label: string }> = {
  amanecer: { bg: '#e9aa3d', ring: '#6f4e37', label: 'Amanecer' },
  arandano: { bg: '#874f9e', ring: '#4a2350', label: 'Arándano' },
  espresso: { bg: '#a97c50', ring: '#2c1e16', label: 'Espresso' },
  menta: { bg: '#3de96a', ring: '#1f4a38', label: 'Menta' },
};

export function paletteColor(p: string) {
  return PALETTE_COLORS[p]?.bg ?? '#888888';
}

export const kWc = (n: number) => (n >= 1024 ? (n / 1024).toFixed(1) + ' KB' : n + ' B');
