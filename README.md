# sha256 prover comparison

Recently I wrote a sha256 compression STARK using [plonky2](https://github.com/mir-protocol/plonky2) that is pretty fast. This repo contains benchmarks running roughly the same thing in groth16, halo2, and maybe more in the future (feel free to add your favorite).

In no way do I guarantee these benchmarks are representative. This should only be taken as a rough ballbark comparison between the proof systems.

## The Benchmark

Since we're comparing SNARKs and STARKs, we're going to benchmark the time it takes to prove a circuit that performs 15 unrelated invocations of the sha2 compression function. That is, sha256, minus the padding step at the beginning. Why 15? Because that's the number of hashes required to build a depth-5 merkle tree given 16 hashes, which is the use case that motivated me to write the plonky2 STARK in the first place. Feel free to change the number of hashes and run the benchmarks however you like.

For Groth16, I wrote a circuit [`sha256_2_x16`](todo) which instantiates 15 instances of the standard `circomlib` circuit `sha256_2`, which does exactly what we want.

For Plonky2, we're using the sha256 compression STARK that I wrote, which can be found [here](https://github.com/proxima-one/plonky2/tree/merkle-stark/merkle-stark/src/sha256_stark)

For Halo2, I took their existing sha256 benchmark and modified the circuit used so that it instantiates 15 instances of their `Table16` chip.

## Running the benchmarks

TODO

### Starky

TODO

### Halo2

TODO

### Groth16

TODO

## The Results

On my 2019 Mac Book Pro...

| proof system           | proving time | hashes/sec |
|------------------------|--------------|------------|
| starky (plonky2 STARK) | 186.25ms     | 80.53      |
| halo2                  | 51.095s      | 0.29       |
| groth16                | 14.447s      | 1.03       |

Don't go off of my numbers, run them yourself.

## Notes

Starky and and halo2 are both in rust, so I used criterion for both. For Groth16 it's all JS. After around 10 minutes of looking I couldn't find a good benchmarking suite for circom, so I wrote a very crude thing that runs the prover 10 times and takes the average. If such a tool exists, feel free to rewrite the circom benchmark using it.

There's probably tons of measurement error in the Groth16 benchmark since I'm including the time it takes node to fork a new process and run the snarkyjs cli in a shell.
