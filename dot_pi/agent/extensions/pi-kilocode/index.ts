/**
 * KiloCode Gateway provider extension for pi
 *
 * Registers the Kilo AI Gateway (https://api.kilo.ai/api/gateway) as a
 * single provider using your personal KILO_API_KEY.
 *
 * Setup:
 *   export KILO_API_KEY=your_key_here
 *
 * Get your API key at: https://app.kilo.ai → Settings → API Keys
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { execFileSync } from "node:child_process";

const GATEWAY_BASE = "https://api.kilo.ai/api/gateway";
const MODELS_URL = `${GATEWAY_BASE}/models`;

interface KiloModel {
  id: string;
  name?: string;
  architecture?: {
    input_modalities?: string[];
  };
  top_provider?: {
    context_length?: number;
    max_completion_tokens?: number;
  };
  pricing?: {
    prompt?: string;
    completion?: string;
    input_cache_read?: string;
    input_cache_write?: string;
  };
  supported_parameters?: string[];
  context_length?: number;
}

function fetchModels(): KiloModel[] {
  try {
    const out = execFileSync(
      "curl",
      ["-s", "--max-time", "10", MODELS_URL],
      { encoding: "utf8" }
    );
    const data = JSON.parse(out);
    return Array.isArray(data.data) ? data.data : [];
  } catch {
    return [];
  }
}

function toPerMillion(value?: string): number {
  const n = parseFloat(value ?? "0");
  return isNaN(n) ? 0 : +(n * 1_000_000).toFixed(6);
}

function toPiModel(m: KiloModel) {
  const rawInput = m.architecture?.input_modalities ?? ["text"];
  const input = rawInput.filter((v): v is "text" | "image" =>
    v === "text" || v === "image"
  );
  if (input.length === 0) input.push("text");

  const reasoning = (m.supported_parameters ?? []).includes("reasoning");
  const contextWindow = m.context_length ?? m.top_provider?.context_length ?? 128_000;
  const maxTokens = m.top_provider?.max_completion_tokens ?? 16_384;

  return {
    id: m.id,
    name: m.name ?? m.id,
    reasoning,
    input,
    cost: {
      input: toPerMillion(m.pricing?.prompt),
      output: toPerMillion(m.pricing?.completion),
      cacheRead: toPerMillion(m.pricing?.input_cache_read),
      cacheWrite: toPerMillion(m.pricing?.input_cache_write),
    },
    contextWindow,
    maxTokens,
  };
}

export default function (pi: ExtensionAPI) {
  const apiKey = process.env.KILO_API_KEY;

  if (!apiKey) {
    pi.on("session_start", async (_event, ctx) => {
      ctx.ui.notify(
        "KiloCode: KILO_API_KEY is not set — kilocode models unavailable.\n" +
        "Run /kilocode for setup instructions.",
        "warning"
      );
    });
    return;
  }

  // Fetch and register models
  const models = fetchModels();
  pi.registerProvider("kilocode", {
    baseUrl: GATEWAY_BASE,
    apiKey: "KILO_API_KEY",
    api: "openai-completions",
    authHeader: true,
    models: models.map(toPiModel),
  });

  /** /kilocode — show provider status */
  pi.registerCommand("kilocode", {
    description: "Show KiloCode status and model count",
    handler: async (_args, ctx) => {
      const key = process.env.KILO_API_KEY;

      const allRegistryModels = ctx.modelRegistry.getAll();
      const kiloModels = allRegistryModels.filter(m => m.provider === "kilocode");

      ctx.ui.notify(
        `KiloCode active ✓\n` +
        `API key: ${key?.slice(0, 8)}…\n` +
        `Models: ${kiloModels.length}\n` +
        `Use /model to select a model`,
        "success"
      );
    },
  });

  /** /kilocode-reload — refresh model list */
  pi.registerCommand("kilocode-reload", {
    description: "Refresh KiloCode model list",
    handler: async (_args, ctx) => {
      const key = process.env.KILO_API_KEY;
      if (!key) {
        ctx.ui.notify("KILO_API_KEY is not set.", "error");
        return;
      }

      ctx.ui.notify("Fetching latest models…", "info");

      // Unregister existing
      pi.unregisterProvider("kilocode");

      // Fetch and re-register
      const newModels = fetchModels();
      pi.registerProvider("kilocode", {
        baseUrl: GATEWAY_BASE,
        apiKey: "KILO_API_KEY",
        api: "openai-completions",
        authHeader: true,
        models: newModels.map(toPiModel),
      });

      ctx.ui.notify(`Reloaded: ${newModels.length} models`, "success");
    },
  });
}