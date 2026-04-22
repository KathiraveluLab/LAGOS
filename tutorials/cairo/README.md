# Cairo Tutorial: Arithmetic Proofs

Cairo is a CPU-like STARK-provable language. In LAGOS, it's used for complex arithmetic tasks—like calculating 99th percentile latencies across hundreds of nodes—in a way that can be proven to be correct without re-executing the entire calculation.

## Roles in LAGOS
1.  **Provable Analytics**: Generating proofs that network latency metrics was calculated accurately.
2.  **Scalability**: STARK proofs are small and fast to verify, even if the calculation itself was massive.
3.  **Governance Audits**: Proving that resource allocation (like bandwidth) followed specific mathematical rules.

## Tutorial: Provable Latency Average

In this tutorial, we will write a simple Cairo program that calculates the average of four latency readings.

### `tutorial.cairo`
```cairo
fn main() {
    let latency1 = 100;
    let latency2 = 120;
    let latency3 = 90;
    let latency4 = 110;

    let sum = latency1 + latency2 + latency3 + latency4;
    let average = sum / 4;

    assert(average == 105, 'Calculation error');
}
```

## Running the Tutorial

To compile and check your Cairo programs, ensure you have the Cairo toolchain installed:

```bash
cairo-compile tutorial.cairo
cairo-run tutorial.json
```

## Key Concepts
- **STARKs**: Scalable Transparent ARguments of Knowledge.
- **Nondeterministic Programming**: High-level language that compiles to provable "trace" files.
- **Built-ins**: Dedicated hardware-like components for hashing and other complex math.
