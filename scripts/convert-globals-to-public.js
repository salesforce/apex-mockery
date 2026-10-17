#!/usr/bin/env node
/**
 * Convert Apex `global` access modifiers to `public` for ISV / managed-package embedding.
 *
 * The shipped unlocked package has no namespace, so `global` and `public` behave the
 * same for most consumers. ISVs who copy `force-app/src/classes` into a managed package
 * often need `public` instead of `global` so the library does not become part of their
 * permanent managed API (see https://github.com/salesforce/apex-mockery/issues/80).
 *
 * Usage:
 *   node scripts/convert-globals-to-public.js              # dry-run on force-app/src/classes
 *   node scripts/convert-globals-to-public.js --write      # rewrite files in place
 *   node scripts/convert-globals-to-public.js path/to/dir --write
 */

const fs = require('fs');
const path = require('path');

const GLOBAL_MODIFIER = /\bglobal\b/g;
const AVOID_GLOBAL_PMD = /,\s*PMD\.AvoidGlobalModifier\b/g;

function parseArgs(argv) {
  const args = { write: false, roots: [] };
  for (const arg of argv) {
    if (arg === '--write' || arg === '-w') {
      args.write = true;
    } else if (arg === '--help' || arg === '-h') {
      args.help = true;
    } else if (!arg.startsWith('-')) {
      args.roots.push(arg);
    } else {
      throw new Error('Unknown option: ' + arg);
    }
  }
  if (args.roots.length === 0) {
    args.roots.push(path.join('force-app', 'src', 'classes'));
  }
  return args;
}

function listClsFiles(root) {
  const abs = path.resolve(root);
  if (!fs.existsSync(abs)) {
    throw new Error('Path not found: ' + abs);
  }
  const stat = fs.statSync(abs);
  if (stat.isFile()) {
    if (!abs.endsWith('.cls')) {
      throw new Error('Not an Apex class file: ' + abs);
    }
    return [abs];
  }
  const files = [];
  const walk = dir => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        walk(full);
      } else if (entry.isFile() && entry.name.endsWith('.cls')) {
        files.push(full);
      }
    }
  };
  walk(abs);
  return files.sort();
}

function convertSource(source) {
  const withoutGlobals = source.replace(GLOBAL_MODIFIER, 'public');
  // Drop obsolete PMD suppressions that only applied to global modifiers.
  const cleaned = withoutGlobals.replace(AVOID_GLOBAL_PMD, '');
  return cleaned;
}

function main() {
  let args;
  try {
    args = parseArgs(process.argv.slice(2));
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
    return;
  }

  if (args.help) {
    console.log('Usage: node scripts/convert-globals-to-public.js [path...] [--write]\n');
    console.log('Convert Apex "global" access modifiers to "public" for managed-package embedding.');
    console.log('Defaults to force-app/src/classes. Pass --write to rewrite files; otherwise dry-run.');
    return;
  }

  const files = args.roots.flatMap(listClsFiles);
  if (files.length === 0) {
    console.error('No .cls files found.');
    process.exitCode = 1;
    return;
  }

  let changedFiles = 0;
  let replacementCount = 0;

  for (const file of files) {
    const original = fs.readFileSync(file, 'utf8');
    const matches = original.match(GLOBAL_MODIFIER);
    const count = matches ? matches.length : 0;
    if (count === 0) {
      continue;
    }
    const next = convertSource(original);
    changedFiles += 1;
    replacementCount += count;
    const rel = path.relative(process.cwd(), file) || file;
    console.log(rel + ': ' + count + ' global -> public');
    if (args.write) {
      fs.writeFileSync(file, next, 'utf8');
    }
  }

  if (changedFiles === 0) {
    console.log('No global modifiers found.');
    return;
  }

  if (args.write) {
    console.log('Updated ' + changedFiles + ' file(s), ' + replacementCount + ' replacement(s).');
  } else {
    console.log('Dry-run: ' + changedFiles + ' file(s), ' + replacementCount + ' replacement(s). Re-run with --write to apply.');
  }
}

if (require.main === module) {
  main();
}

module.exports = { convertSource, parseArgs, listClsFiles };
