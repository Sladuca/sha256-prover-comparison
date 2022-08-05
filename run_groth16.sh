#!/usr/bin/env bash
set -e
script_dir="$(readlink -f "$(dirname "$0")")"

pushd "$script_dir/circomlib"
npm install
node bench_sha256_x15/index.js
popd
