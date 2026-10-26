'use strict';
// Merge enocean.json (add-on config folder) with the Configuration tab's enocean_devices option.
// Usage: node enocean-profiles.js <enocean.json in> <options.json> <enocean.json out>
const fs = require('fs');
const [fileIn, optionsIn, fileOut] = process.argv.slice(2);
const ID = /^[0-9a-f]{8}\/7$/, EEP = /^[0-9A-F]{2}-[0-9A-F]{2}-[0-9A-F]{2}$/;
const merged = {};
let fromFile = 0, fromOptions = 0;

try {
  const m = JSON.parse(fs.readFileSync(fileIn, 'utf8'));
  for (const [id, p] of Object.entries(m)) {
    const key = id.toLowerCase();
    const eepType = String((p && p.eepType) || '').toUpperCase();
    if (!ID.test(key) || !EEP.test(eepType)) {
      console.error(`[enocean] Skipping invalid entry in enocean.json: ${id}`);
      continue;
    }
    merged[key] = { eepType }; fromFile++;
  }
} catch (err) {
  console.error(`[enocean] enocean.json is not valid JSON, ignoring it: ${err.message}`);
}

const opts = JSON.parse(fs.readFileSync(optionsIn, 'utf8'));
for (const d of opts.enocean_devices || []) {
  const key = d.eurid.toLowerCase().replace(/\/7$/, '') + '/7';
  if (merged[key]) console.error(`[enocean] ${key} defined in both places; using Configuration tab value`);
  merged[key] = { eepType: d.eep.toUpperCase() }; fromOptions++;
  console.error(`[enocean] ${key} -> ${d.eep.toUpperCase()}${d.name ? ` (${d.name})` : ''}`);
}

fs.writeFileSync(fileOut, JSON.stringify(merged, null, 2));
console.error(`[enocean] Profiles: ${fromOptions} from Configuration tab, ${fromFile} from enocean.json, ${Object.keys(merged).length} total`);
