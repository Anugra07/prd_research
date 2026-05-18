#!/usr/bin/env node
// micro-bench.js - algorithmic micro-benchmark skeleton for Node.js.
// Fill in setup(), baseline(), treatment(), then:
//   node micro-bench.js
// Output is stable across runs for diffing.

'use strict';

const { execSync } = require('child_process');
const os = require('os');

// ---- TODO: configure ------------------------------------------------------

function setup() {
  // TODO: build whatever your function under test consumes.
  const arr = new Array(100_000);
  for (let i = 0; i < arr.length; i++) arr[i] = (i * 2654435761) >>> 0;
  return arr;
}

function baseline(input) {
  // TODO: replace with the current implementation.
  return [...input].sort((a, b) => b - a);
}

function treatment(input) {
  // TODO: replace with the candidate change.
  const copy = Int32Array.from(input);
  copy.sort();
  // descending
  const out = new Int32Array(copy.length);
  for (let i = 0; i < copy.length; i++) out[i] = copy[copy.length - 1 - i];
  return out;
}

// ---------------------------------------------------------------------------

function percentile(sortedVals, p) {
  if (sortedVals.length === 0) return NaN;
  const k = Math.max(0, Math.min(sortedVals.length - 1, Math.round((p / 100) * (sortedVals.length - 1))));
  return sortedVals[k];
}

function stats(samples) {
  const sorted = samples.slice().sort((a, b) => a - b);
  const n = sorted.length;
  const mean = sorted.reduce((a, b) => a + b, 0) / n;
  const variance = sorted.reduce((a, b) => a + (b - mean) ** 2, 0) / n;
  return {
    p50: percentile(sorted, 50),
    p95: percentile(sorted, 95),
    p99: percentile(sorted, 99),
    mean,
    stdev: Math.sqrt(variance),
    min: sorted[0],
    max: sorted[n - 1],
  };
}

function bench(fn, input, runs, warmup) {
  for (let i = 0; i < warmup; i++) fn(input);
  const samples = new Array(runs);
  for (let i = 0; i < runs; i++) {
    const t0 = process.hrtime.bigint();
    fn(input);
    const t1 = process.hrtime.bigint();
    samples[i] = Number(t1 - t0) / 1_000_000; // ms
  }
  return stats(samples);
}

function gitSha() {
  try {
    return execSync('git rev-parse --short HEAD', { stdio: ['ignore', 'pipe', 'ignore'] })
      .toString()
      .trim();
  } catch {
    return 'uncommitted';
  }
}

function main() {
  const args = process.argv.slice(2);
  const runs = Number(getArg(args, '--runs', 200));
  const warmup = Number(getArg(args, '--warmup', 30));
  const only = getArg(args, '--only', 'both');

  console.log('benchmark: micro-bench.js');
  console.log(`revision:  ${gitSha()}`);
  console.log(`node:      ${process.version}`);
  console.log(`platform:  ${os.type()} ${os.release()} ${os.arch()}`);
  console.log(`runs:      ${runs}`);
  console.log(`warmup:    ${warmup}\n`);

  const input = setup();
  const results = {};

  if (only === 'baseline' || only === 'both') {
    results.baseline = bench(baseline, input, runs, warmup);
  }
  if (only === 'treatment' || only === 'both') {
    results.treatment = bench(treatment, input, runs, warmup);
  }

  for (const [name, s] of Object.entries(results)) {
    console.log(`-- ${name} (ms) --`);
    for (const k of ['p50', 'p95', 'p99', 'mean', 'stdev', 'min', 'max']) {
      console.log(`  ${k.padEnd(5)}: ${s[k].toFixed(4)}`);
    }
    console.log();
  }

  if (results.baseline && results.treatment) {
    const b = results.baseline, t = results.treatment;
    const deltaPct = ((t.p50 - b.p50) / b.p50) * 100;
    const sign = deltaPct >= 0 ? '+' : '';
    const verdict = deltaPct > 0 ? 'slower' : 'faster';
    console.log('-- delta (p50) --');
    console.log(`  treatment is ${sign}${deltaPct.toFixed(2)}% (${verdict})`);
    const noise = (b.stdev / b.mean) * 100;
    console.log(`  baseline noise floor: ~${noise.toFixed(2)}%`);
    console.log('  beware: ignore deltas smaller than the noise floor');
  }
}

function getArg(args, name, def) {
  const i = args.indexOf(name);
  if (i >= 0 && i + 1 < args.length) return args[i + 1];
  return def;
}

main();
