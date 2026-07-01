#!/usr/bin/env node
// scripts/generate_id.js
// 依存ゼロ・高速・環境依存バグの少ない ID 生成（URL-safe, 10文字）
const crypto = require('crypto');

const ALPHABET =
  '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
const SIZE = 10;

const bytes = crypto.randomBytes(SIZE);
let id = '';
for (let i = 0; i < SIZE; i++) {
  id += ALPHABET[bytes[i] % ALPHABET.length];
}
process.stdout.write(id);
