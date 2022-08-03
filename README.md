# sha256 prover benchmarks

Recently I wrote a sha256 compression STARK using [plonky2](https://github.com/mir-protocol/plonky2) that is pretty fast. This repo contains benchmarks running roughly the same thing in groth16, halo2, and maybe more in the future (feel free to add your favorite).

In no way do I guarantee these benchmarks are representative. This should only be taken as a rough ballbark comparison between the proof systems.

## The Benchmark

Since we're comparing SNARKs and STARKs, we're going to benchmark the time it takes to prove a circuit that performs 16 unrelated invocations of the sha2 compression function. That is, sha256, minus the padding step at the beginning.

For Groth16, I wrote a circuit [`sha256_2_x16`](todo) which instantiates 16 instances of the standard `circomlib` circuit `sha256_2`, which does exactly what we want.

For Plonky2, we're using the sha256 compression STARK that I wrote, which can be found [here](https://github.com/proxima-one/plonky2/tree/merkle-stark/merkle-stark/src/sha256_stark)

For Halo2, <!-- TODO -->

## The Results

On my 2019 Mac Book Pro:
<!-- TODO -->
