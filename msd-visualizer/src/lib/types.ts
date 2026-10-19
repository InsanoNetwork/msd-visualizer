export interface ManifestItem {
  pieceId: string;
  artboard: number;
  boardName: string;
  channel: string;
  formatSize: string;
  palette: string;
  theme: string;
}

export interface ManifestExport {
  pieceId: string;
  path: string;
  type: string;
  dimensions: string;
  sizeBytes: number;
  sha256: string;
}

export interface ManifestPart {
  partId: string;
  path: string;
  strategy: string;
  items: ManifestItem[];
  sizeBytes: number;
  limitStatus: string;
  revision: number;
  sha256: string;
}

export interface CampaignManifest {
  schemaVersion: number;
  campaignId: string;
  clientId: string;
  editableFileLimitBytes: number;
  brandKitRef: string | null;
  assetsPolicy: string;
  revision: number;
  worker: string;
  parts: ManifestPart[];
  exports: ManifestExport[];
  previews: Record<string, string>[];
}

export interface Piece {
  pieceId: string;
  artboard: number;
  boardName: string;
  channel: string;
  formatSize: string;
  palette: string;
  theme: string;
}

export interface AuditEntry {
  timestamp: string;
  actorId: string;
  action: string;
  [key: string]: unknown;
}
