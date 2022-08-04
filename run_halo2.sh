#!/usr/bin/env bash
set -e
script_dir="$(readlink -f "$(dirname "$0")")"

pushd "$script_dir/../halo2/halo2_gadgets"
cargo +nightly bench --bench sha256 --features unstable
popd
