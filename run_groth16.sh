#!/usr/bin/env bash
set -e
script_dir="$(readlink -f "$(dirname "$0")")"

pushd "$script_dir/circomlib"
node bench_sha256_x15/index.js
popd
