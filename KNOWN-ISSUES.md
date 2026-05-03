# LAGOS Known Issues

This document tracks known bugs, limitations, and workarounds within the LAGOS framework and its associated polyglot toolchains.

## Roc Compiler Panic: Multiple Effectful Calls (`logic/roc/`)

- **Component**: Real-Time Optimization (Phase 3)
- **Language**: Roc (`roc_nightly`)
- **Status**: Workaround applied.

### Description
The current Roc nightly compiler panics during the monomorphization phase when a `main!` function contains **more than one effectful call** (e.g., multiple `Stdout.line!` invocations):

```text
thread '<unnamed>' panicked at crates/compiler/mono/src/ir.rs:6863:17:
TODO turn fn_var into a RuntimeError
```

This is not limited to numeric formatting — even two consecutive `Stdout.line! "hello"` calls will trigger the crash.

### Root Cause
The panic occurs in the Roc compiler's IR monomorphization pass (`mono/src/ir.rs`). When the compiler attempts to lower multiple sequential effectful (`!`) calls within the same function body, it hits an unfinished code path (`TODO`) and panics instead of emitting a proper error. This is a pre-1.0 compiler limitation.

### Workaround (Applied)
All output is pre-built as a single `Str` using pure functions (`Str.join_with`, `Str.concat`) and then printed with a **single** `Stdout.line!` call in `main!`. This pattern compiles and runs successfully:

```roc
buildReport : {} -> Str
buildReport = \{} ->
    Str.join_with ["line1", "line2", "line3"] "\n"

main! : List Arg => Result {} _
main! = |_args|
    Stdout.line! (buildReport {})
```

### Impact
- `logic/roc/benchmark.roc` — Fully functional with the single-call workaround. Produces the complete MPTCP vs TCP benchmark report.
- `logic/roc/monitor.roc` — Unaffected (designed to be compiled as a C static library via `roc build --lib`, not run as a CLI).
- Two unused-definition warnings remain for `parseBenchmarkLog` and `validateRealNumbers` since they cannot be called from `main!` without introducing a second effectful call. These functions are structurally correct and will be usable once the compiler bug is fixed.
