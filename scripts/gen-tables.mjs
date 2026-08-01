#!/usr/bin/env node
// Regenerates sdk/src/tables.ts from src/beast_definitions.cairo.
//
// The name tables are the one part of the SDK that genuinely duplicates
// contract data, so they are generated rather than transcribed: a hand-copied
// list of 75 species drifts silently, and a wrong species name is a wrong NFT.
//
// Tiers and types are NOT generated — they are formulas (see sdk/src/species.ts),
// and the SDK's tests pin them against the contract's own test anchors.

import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const source = readFileSync(join(root, 'src/beast_definitions.cairo'), 'utf8');

/**
 * Each table is an if/else chain of short-string literals in contract order,
 * with a fallback literal at the end that is not a real entry.
 */
function extractTable(fnName, expected) {
  const start = source.indexOf(`pub fn ${fnName}(`);
  if (start === -1) throw new Error(`could not find ${fnName}`);

  // Run to the next top-level `pub fn`, or the end of the file.
  const next = source.indexOf('\npub fn ', start + 1);
  const body = source.slice(start, next === -1 ? undefined : next);

  const names = [...body.matchAll(/^\s*'([^']*)'/gm)].map((m) => m[1]);
  const entries = names.slice(0, expected);

  if (entries.length !== expected) {
    throw new Error(`${fnName}: expected ${expected} entries, found ${entries.length}`);
  }
  if (entries.some((n) => n.length === 0)) {
    throw new Error(`${fnName}: found an empty entry — the parse is misaligned`);
  }
  return entries;
}

const names = extractTable('get_beast_name', 75);
const prefixes = extractTable('get_prefix', 69);
const suffixes = extractTable('get_suffix', 18);

const block = (arr, perLine = 5) => {
  const lines = [];
  for (let i = 0; i < arr.length; i += perLine) {
    lines.push('  ' + arr.slice(i, i + perLine).map((x) => `'${x}',`).join(' '));
  }
  return lines.join('\n');
};

const output = `// GENERATED from src/beast_definitions.cairo — do not edit by hand.
// Regenerate with \`node scripts/gen-tables.mjs\` from the repo root.
//
// Index 0 of each array is species/affix 1: the contract numbers these from
// 1, and 0 means "absent" for affixes.

/** The 75 genesis species, in contract order (index 0 === species 1). */
export const GENESIS_SPECIES_NAMES: readonly string[] = [
${block(names)}
] as const;

/** Name prefixes 1-69. Shared by every species, genesis and community. */
export const PREFIX_NAMES: readonly string[] = [
${block(prefixes)}
] as const;

/** Name suffixes 1-18. Shared by every species, genesis and community. */
export const SUFFIX_NAMES: readonly string[] = [
${block(suffixes)}
] as const;
`;

writeFileSync(join(root, 'sdk/src/tables.ts'), output);
console.log(
  `Wrote sdk/src/tables.ts: ${names.length} species, ${prefixes.length} prefixes, ${suffixes.length} suffixes`,
);
