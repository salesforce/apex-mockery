const assert = require('assert');
const { convertSource, parseArgs } = require('./convert-globals-to-public.js');

const input = [
  "@SuppressWarnings('PMD.EmptyStatementBlock, PMD.AvoidGlobalModifier')",
  'global class Foo {',
  '  global interface Bar {}',
  '  global void baz() {}',
  '}',
].join('\n');

const output = convertSource(input);
assert.ok(!/\bglobal\b/.test(output), 'no global tokens remain');
assert.ok(output.includes('public class Foo'), 'class becomes public');
assert.ok(output.includes('public interface Bar'), 'interface becomes public');
assert.ok(output.includes('public void baz'), 'method becomes public');
assert.ok(!output.includes('AvoidGlobalModifier'), 'PMD AvoidGlobalModifier removed');
assert.ok(output.includes('PMD.EmptyStatementBlock'), 'other suppressions kept');

const args = parseArgs(['force-app/src/classes', '--write']);
assert.strictEqual(args.write, true);
assert.deepStrictEqual(args.roots, ['force-app/src/classes']);

console.log('convert-globals-to-public.test.js: ok');
