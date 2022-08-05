# sha256 prover comparison

Recently I wrote a sha256 compression STARK using [plonky2](https://github.com/mir-protocol/plonky2) that is pretty fast. This repo contains benchmarks running roughly the same thing in groth16, halo2, and maybe more in the future (feel free to add your favorite).

In no way do I guarantee these benchmarks are representative. This should only be taken as a rough ballbark comparison between the proof systems.

## The Benchmark

Since we're comparing SNARKs and STARKs, we're going to benchmark the time it takes to prove a circuit that performs 15 unrelated invocations of the sha2 compression function. That is, sha256, minus the padding step at the beginning. Why 15? Because that's the number of hashes required to build a depth-5 merkle tree given 16 hashes, which is the use case that motivated me to write the plonky2 STARK in the first place. Feel free to change the number of hashes and run the benchmarks however you like.

For Groth16, I wrote a circuit [`sha256_2_x16`](https://github.com/Sladuca/circomlib/blob/sha2x16-test/circuits/sha256/sha256_2_x15.circom) which instantiates 15 instances of the standard `circomlib` circuit `sha256_2`, which does exactly what we want. I'm using the snarkyjs prove CLI to run the prover.

For Plonky2, we're using the sha256 compression STARK that I wrote, which can be found [here](https://github.com/proxima-one/plonky2/tree/merkle-stark/merkle-stark/src/sha256_stark)

For Halo2, I took their existing sha256 benchmark and modified the circuit used so that it uses the compression function instead of the full hash and invokes it 15 times.

## Running the benchmarks

Dependencies:
- node
- rust (with nightly, install that with `rustup install nightly`)
- circom & snarkjs. See installation instructions for circom and snarkjs [here](https://docs.circom.io/getting-started/installation/). 

1. pull submodules: `git submodule init && git submodule update`
2. run the corresponding script for the benchmark you'd like to run:
  * starky: `./run_starky.sh`
  * halo2: `./run_halo2.sh`
  * groth16: `./run_groth16.sh`. Be warned that the first time around this takes a really long time (~1.5 hours) because of the trusted setup. Any subsequent runs (as long as the `output` directory isn't missing) will re-use the result.

## The Results

On my 2019 MacBook Pro I get the following results for proving 15 invocations of the sha256 compression function:

| proof system           | proving time | hashes/sec |
|------------------------|--------------|------------|
| starky (plonky2 STARK) | 186.25ms     | 80.5       |
| halo2                  | 7.1850s      | 2.08       |
| groth16                | 14.447s      | 1.03       |

Here, starky is ~38x faster than halo2 and ~77x faster than groth16.

My friend [@username](https://www.github.com/sigmachirality) ran them on his 2021 MacBook Pro with an M1 processor and got the following results. He also deserves thanks for cleaning up the groth16 runner script:

| proof system           | proving time | hashes/sec |
|------------------------|--------------|------------|
| starky (plonky2 STARK) | 104.99 ms    | 142.1      |
| halo2                  | 4.1842s      | 3.58       |
| groth16                | 11.589s      | 1.29       |

Here, starky is ~40x faster than halo2 and ~110x faster than groth16.

Don't go off of our numbers, run them yourself.

## Notes

Starky and and halo2 are both in rust, so I used criterion for both. For Groth16 it's all JS. After around 10 minutes of looking I couldn't find a good benchmarking suite for circom, so I wrote a very crude thing that runs the prover 10 times and takes the average. If such a tool exists, feel free to rewrite the circom benchmark using it.

There's probably tons of measurement error in the Groth16 benchmark since I'm including the time it takes node to fork a new process and run the snarkyjs cli in a shell. We're also using the snarkyjs CLI to run the prover here, which doesn't seem to be well-optimized from an implementation standpoint.

This completely ignores compilation / setup costs since the STARK doesn't have a "circuit" to compile. The benchmarker I wrote for groth16 prints times for compilation / setup too.

This also completely ignores proof size, as for the most part nobody cares since 100K isn't actually that large in outside the EVM - it's smaller than many webpages. And if you're verifying in EVM, as long as you have a decent verifier circuit you can always wrap it in a groth16 proof just before submitting to L1.

When running the benchmark with different number of hashes, the comparison changes. For instance, on my machine, starky does around ~88 hashes/sec for 63 and around ~84 hashes/sec for 31.
