#!/usr/bin/env bash
set -e
script_dir="$(readlink -f "$(dirname "$0")")"

pushd "$script_dir/circomlib"
npm install
npm run bench-sha256-x15
popd
