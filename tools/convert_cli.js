#!/usr/bin/env node
/**
 * CVNSS4.0 convert cli
 * Usage:
 *   node tools\convert_cli.js cvn  "toiw"
 *   node tools\convert_cli.js cvss "toiw"
 */
const path = require("path");
const conv = require(path.join(__dirname, "cvnss4.0-converter.js"));

const args = process.argv.slice(2);
const mode = (args[0] || "").toLowerCase();
const input = args.slice(1).join(" ");

if (!mode || !input || !["cvn", "cvss", "cqn"].includes(mode)) {
  process.stderr.write("Usage: node tools\\\\convert_cli.js <cvn|cvss|cqn> <text>\\n");
  process.exit(1);
}

try {
  const out = conv.convert(input, mode);
  process.stdout.write(out.cqn || "");
} catch (e) {
  process.stderr.write(String(e && e.stack ? e.stack : e) + "\\n");
  process.exit(2);
}
