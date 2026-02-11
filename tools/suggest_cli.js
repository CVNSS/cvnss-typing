#!/usr/bin/env node
/**
 * CVNSS4.0 suggestions cli
 * Prints JSON array of up to N candidates.
 *
 * Usage:
 *   node tools\suggest_cli.js cvn "chuc" 6
 */
const path = require("path");
const conv = require(path.join(__dirname, "cvnss4.0-converter.js"));

const args = process.argv.slice(2);
const mode = (args[0] || "").toLowerCase();
const token = (args[1] || "");
const n = Math.max(1, Math.min(12, parseInt(args[2] || "6", 10)));

function titleCase(s){
  if(!s) return s;
  return s.charAt(0).toUpperCase() + s.slice(1);
}
function uniq(arr){
  const out=[];
  const seen=new Set();
  for(const x of arr){
    const k=(x||"").trim();
    if(!k) continue;
    const kk=k.toLowerCase();
    if(seen.has(kk)) continue;
    seen.add(kk);
    out.push(k);
  }
  return out;
}

try{
  if(!mode || !token || !["cvn","cvss"].includes(mode)){
    process.stdout.write("[]");
    process.exit(0);
  }
  const a = conv.convert(token, mode).cqn || token;
  const otherMode = (mode==="cvn") ? "cvss" : "cvn";
  const b = conv.convert(token, otherMode).cqn || "";

  const wantsTitle = token[0] && token[0] === token[0].toUpperCase();

  let cands = [a, b, titleCase(a), titleCase(b), token];
  if(wantsTitle){
    cands = [titleCase(a), titleCase(b), a, b, token];
  }
  cands.push(token.toUpperCase());
  cands = uniq(cands).slice(0, n);
  process.stdout.write(JSON.stringify(cands));
}catch(e){
  process.stdout.write("[]");
}
