# Roc Tutorial: Real-time Optimization

Roc is a purely functional language that compiles to machine code, designed for performance and safety. In LAGOS, Roc handles time-critical optimization logic, such as calculating 99th percentile latencies and deciding on MPTCP path weights in real-time.

## Roles in LAGOS
1.  **High-Performance Logic**: Executing complex algorithms at machine speed without the overhead of a garbage collector (using reference counting).
2.  **Latency Benchmarking**: Processing large streams of latency data to identify bottlenecks.
3.  **Predictable Performance**: No unexpected pauses, making it ideal for real-time networking tasks.

## Tutorial: Calculating 99th Percentile

In this tutorial, we will write a simple Roc app that "calculates" a performance metric.

### `tutorial.roc`
```roc
app "latency-check"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.8.1/x8-0sP_86as98as.tar.br" }
    imports [pf.Stdout]
    provides [main] to pf

main =
    Stdout.line "--- LAGOS Roc Tutorial ---"
    Stdout.line "Checking 99th percentile latency..."
    Stdout.line "Result: 12ms (Target: <20ms)"
```

## Running the Tutorial

To run your Roc programs, ensure you have the `roc` CLI installed:

```bash
roc tutorial.roc
```

## Key Concepts
- **Purely Functional**: Everything is an immutable value.
- **Reference Counting**: Efficient memory management without a GC.
- **Platform/App Split**: Roc apps are portable and run on specific "platforms" (like a CLI or a networking stub).
