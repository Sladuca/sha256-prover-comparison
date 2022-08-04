#!/usr/bin/env bash
set -e
script_dir="$(readlink -f "$(dirname "$0")")"

pushd "$script_dir/../plonky2/merkle-stark"
cargo +nightly bench
popd