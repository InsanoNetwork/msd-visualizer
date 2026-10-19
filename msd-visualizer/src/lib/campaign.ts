// Carga de datos de campaña (build-time only: usa node:fs)
import { readFileSync } from 'node:fs';
import type { CampaignManifest, Piece } from './types';

// Re-export del módulo client-safe para páginas .astro
export {
  PIECE_STATES,
  type PieceState,
  PALETTE_COLORS,
  paletteColor,
  kWc,
} from './campaignStates';

export function loadManifest(): CampaignManifest {
  const raw = readFileSync('./src/data/campaign-manifest.json', 'utf-8');
  return JSON.parse(raw) as CampaignManifest;
}

export function loadAudit(): { timestamp: string; actorId: string; action: string; [k: string]: unknown }[] {
  const raw = readFileSync('./src/data/audit-log.jsonl', 'utf-8');
  return raw
    .split(/\r?\n/)
    .filter((l) => l.trim().length > 0)
    .map((l) => JSON.parse(l));
}

export interface PieceView extends Piece {
  imageUrl: string;
  exportPath: string;
  fileSize: number;
}

const previewByPiece = (pieceId: string) =>
  `/demo/previews/campaign-001-pieza-${pieceId.slice(-3)}.png`;

export function buildPieces(manifest: CampaignManifest): PieceView[] {
  const part = manifest.parts[0];
  const exportMap = new Map(manifest.exports.map((e) => [e.pieceId, e]));
  return part.items.map((item) => {
    const exp = exportMap.get(item.pieceId);
    return {
      ...item,
      imageUrl: previewByPiece(item.pieceId),
      exportPath: exp ? exp.path : '',
      fileSize: exp ? exp.sizeBytes : 0,
    };
  });
}
