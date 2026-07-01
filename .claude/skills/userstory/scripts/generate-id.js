#!/usr/bin/env node
// scripts/generate-id.js
// 依存ゼロ・高速・環境依存バグの少ない ID 生成（URL-safe, 10文字）
const crypto = require('crypto');

const ALPHABET =
  '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
const SIZE = 10;

const id = Array.from(
  crypto.randomBytes(SIZE),
  // byte は 0–255 の整数。% で ALPHABET の範囲（0–61）に収めてインデックスとして使う。
  // Math.random() を使えばシンプルに書けるが、暗号学的に安全でないため
  // crypto.randomBytes() 由来の raw byte をそのまま活用する必要がある。
  (byte) => ALPHABET[byte % ALPHABET.length]
).join('');
process.stdout.write(id);
